import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photos/img/img_addText.dart';

class ImgSetting extends StatefulWidget {
  final AssetEntity assetEntity;
  const ImgSetting({Key? key, required this.assetEntity}) : super(key: key);

  @override
  State<ImgSetting> createState() => _ImgSettingState();
}

class _ImgSettingState extends State<ImgSetting> {
  bool imgSwitcher = true;
  var imgFu;
  var imgFu2;
  late ImageFilter imageFilter;
  Offset? _offset;
  String? text;
  @override
  void initState() {
    img1();
    img2();
    imgFu = widget.assetEntity.originFile;
    imgFu2 = widget.assetEntity.file;
    imageFilter = ImageFilter.blur();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                '发布',
                style: TextStyle(
                    fontSize: 16,
                    foreground: Paint()
                      ..shader = const LinearGradient(colors: [
                        Color(0xff50FDF6),
                        Color(0xff38BAFF),
                      ]).createShader(const Rect.fromLTWH(0, 0, 5, 5))),
              ))
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 41, right: 41, top: 25, bottom: 50),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<File?>(
                future: imgFu,
                builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                  onTap: () {
                                    imgSwitcher = !imgSwitcher;
                                    setState(() {});
                                  },
                                  onLongPress: () {},
                                  child: AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: imgSwitcher
                                        ? ImageFiltered(
                                            key: ValueKey('ImageFiltered'),
                                            imageFilter: imageFilter,
                                            child: Image.file(
                                              snapshot.data!,
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          )
                                        : Image.file(
                                            snapshot.data!,
                                            key: ValueKey('Image'),
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                  )),
                            ),
                          ),
                          Positioned(
                              top: 15,
                              right: 15,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ImgText(
                                                    path: snapshot.data!)))
                                        .then((value) {
                                      if (value != null) {
                                        text = value['text'];
                                        _offset = value['offset'];
                                        setState(() {});
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.text_fields,
                                    color: Colors.white,
                                  ))),
                          if (text != null)
                            Positioned(
                                top: _offset!.dy -
                                    MediaQuery.of(context).padding.top -
                                    56 -
                                    24,
                                left: _offset!.dx - 41,
                                child: Text(
                                  text!,
                                  style: TextStyle(color: Colors.white),
                                ))
                        ],
                      );
                    } else {
                      return const Text(('选择图片错误，请重新选择'));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    imageFilter = ColorFilter.srgbToLinearGamma();
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      buildThumbnail(ColorFilter.srgbToLinearGamma()),
                      Text(
                        '滤镜1',
                        style:
                            TextStyle(color: Color(0xff1c1c1c), fontSize: 14),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 17,
                ),
                GestureDetector(
                  onTap: () {
                    imageFilter = ColorFilter.linearToSrgbGamma();
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      buildThumbnail(ColorFilter.linearToSrgbGamma()),
                      Text(
                        '滤镜1',
                        style:
                            TextStyle(color: Color(0xff1c1c1c), fontSize: 14),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<File?> buildThumbnail(filter) {
    return FutureBuilder<File?>(
      future: imgFu2,
      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ImageFiltered(
                imageFilter: filter,
                child: Image.file(
                  snapshot.data!,
                  width: 48,
                  height: 62,
                  fit: BoxFit.fill,
                ),
              ),
            );
          } else {
            return const Text(('选择图片错误，请重新选择'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void img1() {}

  void img2() {}
}
