import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

HLSQualityLoader? _loader;

HLSQualityLoader get hLSQualityLoader {
  _loader ??= HLSQualityLoader();
  return _loader!;
}

class HLSQualityLoader {
  final _dio = Dio();

  // Future<List<String>> getQualities(String url) async {
  //   final response = await _dio.get(url,
  //       options: Options(
  //         receiveTimeout: const Duration(minutes: 1),
  //       ));
  //   if (response.statusCode != 200) {
  //     return [];
  //   }
  //   final String sData = response.data.toString();
  //   debugPrint('sData: $sData');
  //   final List<String> list = [];
  //   if (sData.contains('#EXT-X-STREAM-INF:')) {
  //     for (final value in sData.split('#EXT-X-STREAM-INF:')) {
  //       List<String> informations = value.split(',');
  //       String trimmedUrl = informations.last.split('/n').last;
  //       if (trimmedUrl.contains('m3u8')) {
  //         if (trimmedUrl.contains('"')) {
  //           trimmedUrl = trimmedUrl.split('"').last.trim();
  //         }
  //         if (trimmedUrl.contains('\n')) {
  //           trimmedUrl = trimmedUrl.trim().split('\n').last.trim();
  //         }
  //         if (trimmedUrl.contains(' ')) {
  //           trimmedUrl = trimmedUrl.trim().split(' ').last.trim();
  //         }
  //         debugPrint('trimmedUrl: $trimmedUrl');
  //         list.add(trimmedUrl);
  //       }
  //     }
  //   }
  //   return list;
  // }

  Future<List<QualityOption>> getQualities(String url) async {
    final base = url.substring(0, url.lastIndexOf('/') + 1);
    List<QualityOption> checkedList = [];
    final response = await _dio.get(url,
        options: Options(
          receiveTimeout: const Duration(minutes: 1),
        ));
    if (response.statusCode != 200) {
      return [];
    }
    final String sData = response.data.toString();
    if (sData.contains('#EXT-X-STREAM-INF:')) {
      for (final value in sData.split('#EXT-X-STREAM-INF:')) {
        List<String> informations = value.split(',');
        String resolution = '';
        for (final inf in informations) {
          if (inf.contains('RESOLUTION=')) {
            resolution = inf.split('RESOLUTION=').last;
            resolution = '${resolution.split('x').last}p';
            break;
          }
        }
        String trimmedUrl = informations.last.split('/n').last;
        if (trimmedUrl.contains('m3u8')) {
          if (trimmedUrl.contains('"')) {
            trimmedUrl = trimmedUrl.split('"').last.trim();
          }
          if (trimmedUrl.contains('\n')) {
            trimmedUrl = trimmedUrl.trim().split('\n').last.trim();
          }
          if (trimmedUrl.contains(' ')) {
            trimmedUrl = trimmedUrl.trim().split(' ').last.trim();
          }
          print(trimmedUrl);
          checkedList
              .add(QualityOption(path: base + trimmedUrl, resolution: resolution));
        }
      }
    }
    return checkedList;
  }
}

class QualityOption {
  String path;
  String resolution;

  QualityOption({
    this.path = '',
    this.resolution = '',
  });
}
