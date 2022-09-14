// GENERATED CODE - DO NOT MODIFY BY HAND

part of rest_json1_v2.rest_json_protocol.model.document_type_as_payload_input_output;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentTypeAsPayloadInputOutput
    extends DocumentTypeAsPayloadInputOutput {
  @override
  final _i2.JsonObject? documentValue;

  factory _$DocumentTypeAsPayloadInputOutput(
          [void Function(DocumentTypeAsPayloadInputOutputBuilder)? updates]) =>
      (new DocumentTypeAsPayloadInputOutputBuilder()..update(updates))._build();

  _$DocumentTypeAsPayloadInputOutput._({this.documentValue}) : super._();

  @override
  DocumentTypeAsPayloadInputOutput rebuild(
          void Function(DocumentTypeAsPayloadInputOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentTypeAsPayloadInputOutputBuilder toBuilder() =>
      new DocumentTypeAsPayloadInputOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentTypeAsPayloadInputOutput &&
        documentValue == other.documentValue;
  }

  @override
  int get hashCode {
    return $jf($jc(0, documentValue.hashCode));
  }
}

class DocumentTypeAsPayloadInputOutputBuilder
    implements
        Builder<DocumentTypeAsPayloadInputOutput,
            DocumentTypeAsPayloadInputOutputBuilder> {
  _$DocumentTypeAsPayloadInputOutput? _$v;

  _i2.JsonObject? _documentValue;
  _i2.JsonObject? get documentValue => _$this._documentValue;
  set documentValue(_i2.JsonObject? documentValue) =>
      _$this._documentValue = documentValue;

  DocumentTypeAsPayloadInputOutputBuilder() {
    DocumentTypeAsPayloadInputOutput._init(this);
  }

  DocumentTypeAsPayloadInputOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documentValue = $v.documentValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentTypeAsPayloadInputOutput other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DocumentTypeAsPayloadInputOutput;
  }

  @override
  void update(void Function(DocumentTypeAsPayloadInputOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentTypeAsPayloadInputOutput build() => _build();

  _$DocumentTypeAsPayloadInputOutput _build() {
    final _$result = _$v ??
        new _$DocumentTypeAsPayloadInputOutput._(documentValue: documentValue);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
