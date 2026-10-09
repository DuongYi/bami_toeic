import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'media_api.freezed.dart';
part 'media_api.g.dart';

/// Supabase Storage: ký URL tạm cho file trong bucket riêng tư.
@RestApi()
abstract class MediaApi {
  factory MediaApi(Dio dio) = _MediaApi;

  @POST('/storage/v1/object/sign/{bucket}')
  Future<List<SignedObject>> signMany(@Path('bucket') String bucket, @Body() SignRequest body);
}

@JsonSerializable(createFactory: false)
class SignRequest {
  const SignRequest({required this.paths, required this.expiresIn});

  final List<String> paths;
  @JsonKey(name: 'expiresIn')
  final int expiresIn;

  Map<String, dynamic> toJson() => _$SignRequestToJson(this);
}

@freezed
abstract class SignedObject with _$SignedObject {
  const factory SignedObject({
    String? path,
    String? error,

    /// Dạng "/object/sign/media/…?token=…" (tương đối với /storage/v1).
    @JsonKey(name: 'signedURL') String? signedUrl,
  }) = _SignedObject;

  factory SignedObject.fromJson(Map<String, dynamic> json) => _$SignedObjectFromJson(json);
}
