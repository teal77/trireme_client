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

import 'common.dart';

Builder apiGenerator(BuilderOptions options) => SharedPartBuilder([
  ApiCallGenerator()
], 'apis', allowSyntaxErrors: true);

class ApiCallGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    var triremeClientClass = library.findType('TriremeClient');
    if (triremeClientClass != null) {
      var generator = _ApiCallCodeGenerator(library.element, buildStep);
      await generator.init();
      return generator.generate(triremeClientClass);
    } else {
      return '';
    }
  }
}

class _ApiCallCodeGenerator extends StringBuffer {
  static const String generatedClassName = '_\$TriremeClientImpl';

  final LibraryElement library;
  final BuildStep buildStep;

  LibraryElement? _libraryDeserialization;

  _ApiCallCodeGenerator(this.library, this.buildStep);

  Future init() async {
    _libraryDeserialization = await buildStep.resolver.libraryFor(
        AssetId.resolve('package:trireme_client/deserialization.dart'.toUri()));
  }

  String generate(ClassElement clazz) {
    writeln('class $generatedClassName extends ${clazz.name} {');
    writeln(
        '$generatedClassName(String username, String password, String host, int port, List<int>? pinnedCert)');
    writeln(': super._(username, password, host, port, pinnedCert);');
    clazz.methods
        .where((m) => m.isAbstract)
        .where((m) => m.metadata.isNotEmpty)
        .forEach((method) {
      generateMethodImpl(method);
    });
    writeln('}');
    return toString();
  }

  void generateMethodImpl(MethodElement method) {
    var returnType = method.returnType.toString();
    var methodName = method.name;
    var methodParameters =
    method.parameters.isEmpty ? '' : method.parameters.join(', ');

    writeln('@override');
    writeln('$returnType $methodName($methodParameters) async {');

    var returnTypeParam =
        (method.returnType as ParameterizedType).typeArguments.first;
    var requestType = returnTypeParam.toString();
    if (isList(returnTypeParam)) {
      requestType = 'List<Object?>';
    } else if (isMap(returnTypeParam)) {
      requestType = 'Map<Object, Object?>';
    } else if (isCustomDeserializingType(returnTypeParam)) {
      requestType = 'Map<Object, Object?>';
    } else if (isResponseWrapper(returnTypeParam)) {
      requestType = 'Response<Object>';
    }

    var apiName = getApiName(library, method);

    var rpcParameters = '';
    if (method.parameters.isNotEmpty) {
      rpcParameters =
          ', ' + method.parameters.map((p) => p.name).toList().toString();
    }

    write("var result = await _client.rpcCall<$requestType>('$apiName'$rpcParameters);");

    if (!isResponseWrapper(returnTypeParam)) {
      generateDeserializing(returnTypeParam, 'result');
    } else {
      var innerType = (returnTypeParam as ParameterizedType).typeArguments.first;
      var intermediateType = '';
      if (isList(innerType)) {
        intermediateType = 'List<Object?>';
      } else if (isMap(innerType)) {
        intermediateType = 'Map<Object, Object?>';
      } else if (isCustomDeserializingType(innerType)) {
        intermediateType = 'Map<Object, Object?>';
      } else {
        intermediateType = innerType.toString();
      }
      writeln('var resultUnwrapped = result.response as $intermediateType;');
      generateDeserializing(innerType, 'resultUnwrapped');
    }

    if (returnTypeParam.isDynamic) {
      writeln('return result;');
    } else if (isResponseWrapper(returnTypeParam)) {
      writeln('return Response(result.apiName, result.requestId, result2);');
    } else {
      writeln('return result2;');
    }

    writeln('}');
  }

  void generateDeserializing(DartType returnTypeParam, String argumentName) {
    if (returnTypeParam is ParameterizedType) {
      var typeArguments = returnTypeParam.typeArguments;
      if (isList(returnTypeParam)) {
        var listTypeArgument = typeArguments.first;
        if (isCustomDeserializingType(listTypeArgument)) {
          writeln(
              'var deserializer = CustomDeserializerFactory().createDeserializer($listTypeArgument) as CustomDeserializer<$listTypeArgument>;');
          writeln(
              'var result2 = $argumentName.map((e) => deserializer.deserialize(e));');
        } else {
          writeln('var result2 = $argumentName.cast<$listTypeArgument>();');
        }
      } else if (isMap(returnTypeParam)) {
        var keyTypeArgument = typeArguments[0];
        var valueTypeArgument = typeArguments[1];
        if (isCustomDeserializingType(valueTypeArgument)) {
          writeln(
              'var deserializer = CustomDeserializerFactory().createDeserializer($valueTypeArgument) as CustomDeserializer<$valueTypeArgument>;');
          writeln(
              'var result2 = $argumentName.map((k, v) => MapEntry(k as $keyTypeArgument, deserializer.deserialize(v)));');
        } else {
          writeln(
              'var result2 = $argumentName.cast<$keyTypeArgument, $valueTypeArgument>();');
        }
      } else if (isCustomDeserializingType(returnTypeParam)) {
        writeln(
            'var deserializer = CustomDeserializerFactory().createDeserializer($returnTypeParam) as CustomDeserializer<$returnTypeParam>;');
        writeln('var result2 = deserializer.deserialize($argumentName);');
      } else {
        writeln('var result2 = $argumentName;');
      }
    }
  }

  String getApiName(LibraryElement library, MethodElement method) {
    var annotation = getAnnotationOfType(library.getClass('ApiName')!.thisType, method);
    var apiNameStr = annotation!.getField('name')!.toStringValue();
    return apiNameStr!;
  }

  bool isList(DartType type) {
    return type.element == library.typeProvider.listElement;
  }

  bool isMap(DartType type) {
    return type.element == library.typeProvider.mapElement;
  }

  bool isCustomDeserializingType(DartType type) {
    var annotation = getAnnotationOfType(_libraryDeserialization!.getClass('CustomDeserialize')!.thisType, type.element!);
    return annotation != null;
  }

  bool isResponseWrapper(DartType type) {
    return type.element!.name == 'Response';
  }
}
