/*
 * Trireme Client - Deluge RPC Client for Dart.
 * Copyright (C) 2018  Aashrava Holla
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:trireme_client/deserialization.dart';

import 'common.dart';

class DeserializationGenerator
    extends GeneratorForAnnotation<CustomDeserialize> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return new _DeserializationCodeGenerator(element.library)
        .generate(element as ClassElement);
  }
}

class _DeserializationCodeGenerator extends StringBuffer {
  final LibraryElement library;

  _DeserializationCodeGenerator(this.library);

  String generate(ClassElement clazz) {
    writeln("class \$${clazz
        .name}CustomDeserializer extends CustomDeserializer<${clazz.name}>{");
    writeln("${clazz.name} deserialize(Object o) {");
    generateDeserializationMethodBody(clazz);
    writeln("}");
    writeln("}");
    generateDeserializationKeyList(clazz);

    return toString();
  }

  Iterable<FieldElement> getFieldsWithoutExcludedAnnotation(
      ClassElement clazz) {
    return clazz.fields.where((f) {
      if (f.metadata.isNotEmpty) {
        var excludeAnnotation =
            getAnnotationOfType(library.getType("Exclude").type, f);
        return excludeAnnotation == null;
      } else {
        return true;
      }
    });
  }

  void generateDeserializationMethodBody(ClassElement clazz) {
    writeln("var oAsMap = (o as Map<Object, Object>);");
    writeln("var map = oAsMap.cast<String, Object>();");
    writeln("${clazz.name} item = new ${clazz.name}();");
    getFieldsWithoutExcludedAnnotation(clazz).forEach((f) {
      String mapKey = getMapKeyOfField(f);

      if (f.type.name == "List") {
        var listTypeParam = (f.type as ParameterizedType).typeArguments.first;
        if (isCustomDeserializableType(listTypeParam.element)) {
          write("CustomDeserializer<$listTypeParam> deserializer");
          writeln(
              "= new CustomDeserializerFactory().createDeserializer(${listTypeParam}) as CustomDeserializer<$listTypeParam>;");
          writeln("item.${f
              .name} = (map['$mapKey'] as List<Object>)?.map((e) => deserializer.deserialize(e))?.toList();");
        } else {
          writeln("item.${f.name} = (map['$mapKey'] as ${f.type
              .name})?.cast<$listTypeParam>();");
        }
      } else {
        writeln("item.${f.name} = map['$mapKey'] as ${f.type.name};");
      }
    });
    writeln("return item;");
  }

  String getMapKeyOfField(FieldElement f) {
    var mapKeyAnnotation =
        getAnnotationOfType(library.getType("MapKey").type, f);
    return mapKeyAnnotation == null
        ? f.name
        : mapKeyAnnotation.getField("key").toStringValue();
  }

  bool isCustomDeserializableType(Element e) {
    return getAnnotationOfType(library.getType("CustomDeserialize").type, e) !=
        null;
  }

  void generateDeserializationKeyList(ClassElement clazz) {
    String getCamelCaseName(String name) {
      return "${name[0].toLowerCase()}${name.substring(1)}";
    }

    writeln("const ${getCamelCaseName(clazz.name)}Keys = const [");
    getFieldsWithoutExcludedAnnotation(clazz).forEach((f) {
      writeln("'${getMapKeyOfField(f)}',");
    });
    writeln("];");
  }
}

class DeserializationFactoryGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    var factoryClass = library.element.getType("CustomDeserializerFactory");
    if (factoryClass == null) {
      return null;
    } else {
      return new _DeserializationFactoryGenerator()
          .generate(factoryClass, library.element);
    }
  }
}

class _DeserializationFactoryGenerator extends StringBuffer {
  Future<String> generate(ClassElement factoryClass, LibraryElement l) async {
    writeln(
        "class \$CustomDeserializerFactoryImpl extends CustomDeserializerFactory {");
    writeln("\$CustomDeserializerFactoryImpl() : super._();");
    writeln("@override");
    writeln("CustomDeserializer createDeserializer(Type modelClass) {");
    writeln("switch(modelClass) {");
    l.definingCompilationUnit.types
        .where((e) => e.metadata.isNotEmpty)
        .forEach((e) {
      writeln("case ${e.name}:");
      writeln("return new \$${e.name}CustomDeserializer();");
      writeln("break;");
    });
    writeln("}");
    writeln("throw 'Unsupported type \$modelClass';");
    writeln("}");
    writeln("}");

    return toString();
  }
}
