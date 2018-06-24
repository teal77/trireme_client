import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'common.dart';

class ApiCallGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    var triremeClientClass = library.findType("TriremeClient");
    if (triremeClientClass != null) {
      var generator = new _ApiCallCodeGenerator(library.element, buildStep);
      await generator.init();
      return generator.generate(triremeClientClass);
    } else {
      return null;
    }
  }
}

class _ApiCallCodeGenerator extends StringBuffer {
  static const String generatedClassName = "_\$TriremeClientImpl";

  final LibraryElement library;
  final BuildStep buildStep;

  LibraryElement _libraryDeserialization;

  _ApiCallCodeGenerator(this.library, this.buildStep);

  Future init() async {
    _libraryDeserialization = await buildStep.resolver.libraryFor(
        new AssetId.resolve("package:trireme_client/deserialization.dart"));
  }

  String generate(ClassElement clazz) {
    writeln("class $generatedClassName extends ${clazz.name} {");
    writeln(
        "$generatedClassName(String username, String password, String host, int port)");
    writeln(": super._(username, password, host, port);");
    clazz.methods
        .where((m) => m.isAbstract)
        .where((m) => m.metadata.isNotEmpty)
        .forEach((method) {
      generateMethodImpl(method);
    });
    writeln("}");
    return toString();
  }

  void generateMethodImpl(MethodElement method) {
    var returnType = method.returnType.toString();
    var methodName = method.name;
    var methodParameters =
        method.parameters.isEmpty ? "" : method.parameters.join(", ");

    writeln("$returnType $methodName($methodParameters) async {");

    var returnTypeParam =
        (method.returnType as ParameterizedType).typeArguments.first;
    var requestType = returnTypeParam.toString();
    if (isList(returnTypeParam)) {
      requestType = "List<Object>";
    } else if (isMap(returnTypeParam)) {
      requestType = "Map<Object, Object>";
    } else if (isCustomDeserializingType(returnTypeParam)) {
      requestType = "Map<Object, Object>";
    }

    var apiName = getApiName(library, method);

    var rpcParameters = "";
    if (method.parameters.isNotEmpty) {
      rpcParameters =
          ", " + method.parameters.map((p) => p.name).toList().toString();
    }

    write(
        "$requestType result = await _client.rpcCall<$requestType>('$apiName'$rpcParameters);");

    if (returnTypeParam is ParameterizedType) {
      var typeArguments = returnTypeParam.typeArguments;
      if (isList(returnTypeParam)) {
        var listTypeArgument = typeArguments.first;
        if (isCustomDeserializingType(listTypeArgument)) {
          writeln(
              "CustomDeserializer<$listTypeArgument> deserializer = new CustomDeserializerFactory().createDeserializer($listTypeArgument);");
          writeln(
              "var result2 = result.map((e) => deserializer.deserialize(e));");
        } else {
          writeln("var result2 = result.cast<$listTypeArgument>();");
        }
      } else if (isMap(returnTypeParam)) {
        var keyTypeArgument = typeArguments[0];
        var valueTypeArgument = typeArguments[1];
        if (isCustomDeserializingType(valueTypeArgument)) {
          writeln(
              "CustomDeserializer<$valueTypeArgument> deserializer = new CustomDeserializerFactory().createDeserializer($valueTypeArgument);");
          writeln(
              "var result2 = result.map((k, v) => new MapEntry(k as $keyTypeArgument, deserializer.deserialize(v)));");
        } else {
          writeln(
              "var result2 = result.cast<$keyTypeArgument, $valueTypeArgument>();");
        }
      } else if (isCustomDeserializingType(returnTypeParam)) {
        writeln(
            "CustomDeserializer<$returnTypeParam> deserializer = new CustomDeserializerFactory().createDeserializer($returnTypeParam);");
        writeln("var result2 = deserializer.deserialize(result);");
      } else {
        writeln("var result2 = result;");
      }
    }

    if (returnTypeParam.isDynamic) {
      writeln("return result;");
    } else {
      writeln("return result2;");
    }

    writeln("}");
  }

  String getApiName(LibraryElement library, MethodElement method) {
    var annotation =
        getAnnotationOfType(library.getType("ApiName").type, method);

    var apiNameStr = annotation.getField("name").toStringValue();
    return apiNameStr;
  }

  bool isList(DartType type) {
    return type.element.name == "List";
  }

  bool isMap(DartType type) {
    return type.element.name == "Map";
  }

  bool isCustomDeserializingType(DartType type) {
    var annotation = getAnnotationOfType(
        _libraryDeserialization.getType("CustomDeserialize").type,
        type.element);
    return annotation != null;
  }
}
