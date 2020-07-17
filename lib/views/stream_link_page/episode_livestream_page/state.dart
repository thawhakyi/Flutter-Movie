import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/base_api_model/tvshow_stream_link.dart';
import 'package:movie/models/episodemodel.dart';
import 'package:movie/models/seasondetail.dart';
import 'package:movie/views/stream_link_page/episode_livestream_page/components/bottom_panel_component/components/comment_component/state.dart';
import 'package:movie/views/stream_link_page/episode_livestream_page/components/bottom_panel_component/state.dart';

import 'components/player_component/state.dart';

class EpisodeLiveStreamState implements Cloneable<EpisodeLiveStreamState> {
  int tvid;
  TvShowStreamLinks streamLinks;
  TvShowStreamLink selectedLink;
  Episode selectedEpisode;
  Season season;
  ScrollController scrollController;
  PlayerState playerState;
  BottomPanelState bottomPanelState;

  @override
  EpisodeLiveStreamState clone() {
    return EpisodeLiveStreamState()
      ..tvid = tvid
      ..season = season
      ..streamLinks = streamLinks
      ..selectedEpisode = selectedEpisode
      ..scrollController = scrollController
      ..playerState = playerState
      ..bottomPanelState = bottomPanelState
      ..selectedLink = selectedLink;
  }
}

EpisodeLiveStreamState initState(Map<String, dynamic> args) {
  EpisodeLiveStreamState state = EpisodeLiveStreamState();
  state.tvid = args['tvid'];
  state.season = args['season'];
  state.selectedEpisode = args['selectedEpisode'];
  state.bottomPanelState = BottomPanelState()
    ..tvId = state.tvid
    ..season = state.season.seasonNumber
    ..useVideoSourceApi = true
    ..streamInBrowser = false
    ..commentState = CommentState()
    ..likeCount = 0
    ..userLiked = false;
  state.playerState = PlayerState()
    ..background = state.selectedEpisode.stillPath;
  return state;
}
