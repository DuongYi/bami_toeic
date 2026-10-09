// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$GoalsUpsertToJson(GoalsUpsert instance) =>
    <String, dynamic>{
      'target_score': instance.targetScore,
      'exam_date': instance.examDate,
      'daily_questions': instance.dailyQuestions,
      'daily_words': instance.dailyWords,
      'daily_dictations': instance.dailyDictations,
      'reminder_minutes': instance.reminderMinutes,
      'updated_at': instance.updatedAt.toIso8601String(),
    };

Map<String, dynamic> _$StudyDayBumpToJson(StudyDayBump instance) =>
    <String, dynamic>{
      'p_day': instance.day,
      'p_questions': instance.questions,
      'p_mistakes': instance.mistakes,
      'p_words': instance.words,
      'p_dictations': instance.dictations,
    };

StudyDayRow _$StudyDayRowFromJson(Map<String, dynamic> json) => StudyDayRow(
  day: json['day'] as String,
  questions: (json['questions'] as num?)?.toInt() ?? 0,
  mistakes: (json['mistakes'] as num?)?.toInt() ?? 0,
  words: (json['words'] as num?)?.toInt() ?? 0,
  dictations: (json['dictations'] as num?)?.toInt() ?? 0,
);

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: type=lint
// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _GoalsApi implements GoalsApi {
  _GoalsApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<List<GoalSettings>> getGoals() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<GoalSettings>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/rest/v1/user_goals',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<GoalSettings> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => GoalSettings.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> upsertGoals(GoalsUpsert body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Prefer': 'resolution=merge-duplicates,return=minimal',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<void>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/rest/v1/user_goals',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<List<StudyDayRow>> getStudyDays({
    required String since,
    String select = 'day,questions,mistakes,words,dictations',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'day': since, r'select': select};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<StudyDayRow>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/rest/v1/study_days',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<StudyDayRow> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => StudyDayRow.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> bumpStudyDay(StudyDayBump body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<void>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/rest/v1/rpc/bump_study_day',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
