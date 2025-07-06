import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/http/results/app_model.dart';
import '../models/http/results/carousel_model.dart';
import '../models/http/results/config_model.dart';
import '../models/http/results/latest_version_model.dart';
import '../models/http/results/lzy_dir_parse_model.dart';
import '../models/http/results/lzy_dir_search_model.dart';
import '../models/http/results/lzy_file_info_model.dart';
import '../models/http/results/lzy_file_parse_model.dart';
import '../models/http/results/referral_model.dart';
import '../models/http/results/report_cat_list_model.dart';
import '../models/http/results/report_cat_model.dart';
import '../models/http/results/report_model.dart';
import '../models/http/results/version_model.dart';
import '../models/http/results/word_model.dart';

part 'http_api.g.dart';

// @RestApi(baseUrl: 'http://10.0.2.2:8080')
@RestApi(baseUrl: 'https://api.krrz.cn')
abstract class HttpApi {
  factory HttpApi(Dio dio, {String baseUrl}) = _HttpApi;

  ///获取配置
  @GET('/api/softlib/Config')
  Future<ConfigModel> getConfig();

  ///首页轮播图
  @GET('/api/softlib/Carousel')
  Future<CarouselModel> getCarousel();

  ///首页推荐
  @GET('/api/softlib/Referral')
  Future<ReferralModel> getReferral();

  ///软件列表
  @GET('/api/softlib/App')
  Future<AppModel> getApp();

  ///软件版本列表
  @GET('/api/softlib/Version')
  Future<VersionModel> getVersion();

  ///软件最新版本
  @GET('/api/softlib/Version')
  Future<LatestVersionModel> getLatestVersion(@Query('version') String version);

  ///线报分类
  @GET('/api/softlib/Report')
  Future<ReportCatModel> getReportCat();

  ///线报分类列表
  @GET('/api/softlib/Report')
  Future<ReportCatListModel> getReportCatLis({
    @Query('catId') String? catId,
    @Query('pages') int? page,
  });

  ///线报详情
  @GET('/api/softlib/Report')
  Future<ReportModel> getReport(@Query('articleID') int articleID);

  ///********************

  ///蓝奏云目录解析
  @GET('/api/softlib/lzy_dir_parse')
  Future<LzyDirParseModel> getLzyDirParse({
    @Query('url') String? url,
    @Query('pgs') int? pgs,
    @Query('pwd') String? pwd,
  });

  ///蓝奏云目录搜索
  @GET('/api/softlib/Lzy_dir_search')
  Future<LzyDirSearchModel> getLzyDirSearch({
    @Query('url') String? url,
    @Query('keyword') String? keyword,
  });

  ///蓝奏云文件信息
  @GET('/api/softlib/lzy_file_info')
  Future<LzyFileInfoModel> getLzyFileInfo(@Query('url') String? url);

  ///蓝奏云文件解析
  @GET('/api/softlib/lzy_file_parse')
  Future<LzyFileParseModel> getLzyFileParse(@Query('url') String? url);

  ///蓝奏云文件解析
  @GET('/api/softlib/Word')
  Future<WordModel> getWord();
}
