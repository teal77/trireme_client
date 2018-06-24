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

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

DartObject getAnnotationOfType(DartType type, Element element) {
  var annotation = element.metadata.firstWhere((e) {
    if (e.element.kind == ElementKind.CONSTRUCTOR) {
      return (e.element.enclosingElement as TypeDefiningElement)
          .type
          .isAssignableTo(type);
    } else if (e.element.kind == ElementKind.GETTER) {
      return (e.element as PropertyAccessorElement)
          .variable
          .type
          .isAssignableTo(type);
    } else {
      throw "Annotation of type ${e.element.kind} is not handled";
    }
  }
      , orElse: () => null);
  return annotation?.constantValue;
}
