# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: http_record.proto
# Protobuf Python Version: 5.26.1
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import symbol_database as _symbol_database
from google.protobuf.internal import builder as _builder
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x11http_record.proto\x12\x11MahimahiProtobufs\"^\n\x0bHTTPMessage\x12\x12\n\nfirst_line\x18\x01 \x01(\x0c\x12-\n\x06header\x18\x02 \x03(\x0b\x32\x1d.MahimahiProtobufs.HTTPHeader\x12\x0c\n\x04\x62ody\x18\x03 \x01(\x0c\"(\n\nHTTPHeader\x12\x0b\n\x03key\x18\x01 \x01(\x0c\x12\r\n\x05value\x18\x02 \x01(\x0c\"\xe8\x01\n\x0fRequestResponse\x12\n\n\x02ip\x18\x01 \x01(\t\x12\x0c\n\x04port\x18\x02 \x01(\r\x12\x39\n\x06scheme\x18\x03 \x01(\x0e\x32).MahimahiProtobufs.RequestResponse.Scheme\x12/\n\x07request\x18\x04 \x01(\x0b\x32\x1e.MahimahiProtobufs.HTTPMessage\x12\x30\n\x08response\x18\x05 \x01(\x0b\x32\x1e.MahimahiProtobufs.HTTPMessage\"\x1d\n\x06Scheme\x12\x08\n\x04HTTP\x10\x01\x12\t\n\x05HTTPS\x10\x02')

_globals = globals()
_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, _globals)
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'http_record_pb2', _globals)
if not _descriptor._USE_C_DESCRIPTORS:
  DESCRIPTOR._loaded_options = None
  _globals['_HTTPMESSAGE']._serialized_start=40
  _globals['_HTTPMESSAGE']._serialized_end=134
  _globals['_HTTPHEADER']._serialized_start=136
  _globals['_HTTPHEADER']._serialized_end=176
  _globals['_REQUESTRESPONSE']._serialized_start=179
  _globals['_REQUESTRESPONSE']._serialized_end=411
  _globals['_REQUESTRESPONSE_SCHEME']._serialized_start=382
  _globals['_REQUESTRESPONSE_SCHEME']._serialized_end=411
# @@protoc_insertion_point(module_scope)
