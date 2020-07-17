import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:movie/actions/http/base_api.dart';
import 'package:movie/globalbasestate/store.dart';
import 'package:movie/models/base_api_model/tvshow_like_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'action.dart';
import 'state.dart';

Effect<BottomPanelState> buildEffect() {
  return combineEffects(<Object, Effect<BottomPanelState>>{
    BottomPanelAction.action: _onAction,
    Lifecycle.initState: _onInit,
    BottomPanelAction.useVideoSource: _useVideoSource,
    BottomPanelAction.streamInBrowser: _streamInBrowser,
    BottomPanelAction.commentTap: _commentTap,
    BottomPanelAction.likeTvShow: _likeTvShow,
  });
}

void _onAction(Action action, Context<BottomPanelState> ctx) {}

void _useVideoSource(Action action, Context<BottomPanelState> ctx) async {
  final bool _b = action.payload;
  final _pre = await SharedPreferences.getInstance();
  _pre.setBool('useVideoSourceApi', _b);
  ctx.dispatch(BottomPanelActionCreator.setUseVideoSource(_b));
}

void _streamInBrowser(Action action, Context<BottomPanelState> ctx) async {
  final bool _b = action.payload;
  final _pre = await SharedPreferences.getInstance();
  _pre.setBool('streamInBrowser', _b);
  ctx.dispatch(BottomPanelActionCreator.setStreamInBrowser(_b));
}

Future _commentTap(Action action, Context<BottomPanelState> ctx) async {
  await Navigator.of(ctx.context).push(
    PageRouteBuilder(
        barrierColor: const Color(0xAA000000),
        fullscreenDialog: true,
        barrierDismissible: true,
        opaque: false,
        pageBuilder: (context, animation, subAnimation) {
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0.3))
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.ease)),
            child: ctx.buildComponent('comments'),
          );
        }),
  );
}

void _onInit(Action action, Context<BottomPanelState> ctx) async {
  bool _useVideoSourceApi = false;
  bool _streamInBrowser = false;
  final _pre = await SharedPreferences.getInstance();
  if (_pre.containsKey('useVideoSourceApi'))
    _useVideoSourceApi = _pre.getBool('useVideoSourceApi');
  if (_pre.containsKey('streamInBrowser'))
    _streamInBrowser = _pre.getBool('streamInBrowser');
  ctx.dispatch(
      BottomPanelActionCreator.setOption(_useVideoSourceApi, _streamInBrowser));
}

Future _likeTvShow(Action action, Context<BottomPanelState> ctx) async {
  final user = GlobalStore.store.getState().user;
  int _likeCount = ctx.state.likeCount;
  bool _userLike = ctx.state.userLiked;
  if (user?.firebaseUser == null) return;
  _userLike ? _likeCount-- : _likeCount++;
  ctx.dispatch(BottomPanelActionCreator.setLike(_likeCount, !_userLike));
  final _likeModel = TvShowLikeModel.fromParams(
      tvId: ctx.state.tvId,
      season: ctx.state.season,
      episode: ctx.state.selectEpisode,
      id: 0,
      uid: user.firebaseUser.uid);

  final _result = _userLike
      ? await BaseApi.instance.unlikeTvShow(_likeModel)
      : await BaseApi.instance.likeTvShow(_likeModel);
  print(_result.result);
}
