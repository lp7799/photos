import 'dart:io';

import 'package:flutter/material.dart';

class ImgText extends StatefulWidget {
  final File path;
  const ImgText({Key? key, required this.path}) : super(key: key);

  @override
  State<ImgText> createState() => _ImgTextState();
}

class _ImgTextState extends State<ImgText> {
  Offset? offset;
  bool pan = false;
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            onLongPressEnd: (LongPressEndDetails l) {
              if (offset == null) {
                offset = l.localPosition;
                setState(() {});
              }
            },
            child: Image.file(
              widget.path,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 28,
                right: 28,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.white),
                      )),
                  Builder(builder: (context) {
                    return TextButton(
                        onPressed: () {
                          if (controller.text == '' && offset == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                '请输入文字哦',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                            ));
                          } else {
                            Navigator.pop(context,
                                {'text': controller.text, 'offset': offset});
                          }
                        },
                        child: Text(
                          '完成',
                          style: TextStyle(color: Colors.blue),
                        ));
                  })
                ],
              ),
            ),
          ),
          if (offset != null)
            Positioned(
                left: offset!.dx,
                top: offset!.dy,
                child: GestureDetector(
                  onPanUpdate: (d) {
                    if (offset != null) {
                      if (d.globalPosition.dy >=
                          (MediaQuery.of(context).size.height - 150)) {
                        offset = null;
                        controller.clear();
                      } else {
                        offset = d.globalPosition;
                      }

                      setState(() {});
                    }
                  },
                  onPanStart: (d) {
                    if (offset != null) {
                      pan = true;
                      offset = d.globalPosition;
                      setState(() {});
                    }
                  },
                  onTapUp: (d) {
                    if (offset != null) {}
                  },
                  child: SizedBox(
                    width: 100,
                    height: 38,
                    child: TextFormField(
                      autofocus: false,
                      controller: controller,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      decoration: InputDecoration(
                        hintText: '输入文字',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                )),
          if (offset != null)
            Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.white.withOpacity(.5),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ))
        ],
      ),
    );
  }
}
