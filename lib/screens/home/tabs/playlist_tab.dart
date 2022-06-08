import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/widgets/add_songs_playlist.dart';
import 'package:tunes/widgets/dialog_box.dart';
import 'package:tunes/widgets/widgets.dart';

class PlayListTab extends StatefulWidget {
  const PlayListTab({Key? key}) : super(key: key);

  @override
  State<PlayListTab> createState() => _PlayListTabState();
}

class _PlayListTabState extends State<PlayListTab> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<PlaylistModel> playlists = [];
  final TextEditingController _playlistFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    getPlaylists();
  }

  @override
  void dispose() {
    _playlistFieldController.dispose();
    super.dispose();
  }

  getPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    var allPlaylists = prefs.getStringList("playlists");
    print(allPlaylists);

    var _playlist = await _audioQuery.queryPlaylists();
    setState(() => playlists = _playlist);
  }

  createPlaylist() async {
    final playlistName = _playlistFieldController.text;
    if (playlistName.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        "playlists", [...?prefs.getStringList("playlists"), playlistName]);

    _playlistFieldController.text = "";
    await getPlaylists();
  }

  deletePlaylist(int playlistId) async {
    var result = await _audioQuery.removePlaylist(playlistId);
    print(result);
    await getPlaylists();
  }

  showCreateNewPlaylistModal(context) {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        title: "New",
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _playlistFieldController,
              autofocus: true,
              placeholder: "New awesome playlist ✨",
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: textColor),
                ),
                IconButton(
                  onPressed: () {
                    createPlaylist();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Created new playlist (^^)"),
                    ));
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check, color: textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Stack(
        children: [
          playlists.isNotEmpty
              ? ListView.builder(
                  itemCount: playlists.length,
                  addAutomaticKeepAlives: true,
                  padding: const EdgeInsets.only(bottom: 150),
                  itemBuilder: (context, index) {
                    var playlist = playlists[index];
                    return PlaylistCard(
                      playlistModel: playlist,
                      onDeletePlaylistButtonPressed: deletePlaylist,
                      onAddSongsButtonPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddSongsPage(playlistId: playlist.id),
                        ),
                      ).then((_) => getPlaylists()),
                    );
                  },
                )
              : const SizedBox.shrink(),
          Positioned(
            right: 10,
            bottom: 170,
            child: GestureDetector(
              onTap: () => showCreateNewPlaylistModal(context),
              child: Container(
                decoration: const BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.add,
                  color: textColor,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
