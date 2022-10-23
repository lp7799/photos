import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photos/img/img_setting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectImg extends StatefulWidget {
  const SelectImg({Key? key}) : super(key: key);

  @override
  State<SelectImg> createState() => _SelectImgState();
}

class _SelectImgState extends State<SelectImg> {
  final ValueNotifier<List<AssetEntity>> imgs = ValueNotifier([]);
  late List<AssetPathEntity> paths;
  @override
  void initState() {
    getImg();
    super.initState();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  void _onRefresh(AssetPathEntity assetPathEntity) async {
    page = 0;
    imgs.value = await assetPathEntity.getAssetListPaged(page: page, size: 30);

    _refreshController.refreshCompleted();
  }

  void _onLoading(AssetPathEntity assetPathEntity) async {
    page++;
    final data = await assetPathEntity
        .getAssetListPaged(page: page, size: 30)
        .catchError((e) {
      _refreshController.loadComplete();
      _refreshController.loadFailed();
    });
    if (data.isNotEmpty) {
      imgs.value.addAll(data);
      imgs.notifyListeners();
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择照片'),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xd9000000)),
        titleTextStyle: TextStyle(fontSize: 16, color: Color(0xd9000000)),
      ),
      body: FutureBuilder<List<AssetPathEntity>>(
          future: getImg(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<AssetPathEntity> paths = snapshot.data!;
              return ValueListenableBuilder(
                valueListenable: imgs,
                builder: (BuildContext context, List<AssetEntity> value,
                    Widget? child) {
                  return SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    enableTwoLevel: false,
                    onRefresh: () async {
                      _onRefresh(paths.first);
                    },
                    onLoading: () {
                      _onLoading(paths.first);
                    },
                    child: GridView.builder(
                        itemCount: imgs.value.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6),
                        itemBuilder: (context, index) {
                          final AssetEntity assetEntity = imgs.value[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ImgSetting(
                                          assetEntity: assetEntity)));
                            },
                            child: AssetEntityImage(
                              assetEntity,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              isOriginal: false, // Defaults to `true`.
                              thumbnailSize: const ThumbnailSize.square(
                                  200), // Preferred value.
                              thumbnailFormat:
                                  ThumbnailFormat.jpeg, // Defaults to `jpeg`.
                            ),
                          );
                        }),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<List<AssetPathEntity>> getImg() async {
    final p = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    imgs.value = await p.first.getAssetListPaged(page: 0, size: 30);
    return p;
  }
}
