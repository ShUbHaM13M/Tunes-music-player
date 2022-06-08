import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/screens/playlist_detail/playlist_detail.dart';
import 'package:tunes/utils/colors.dart';
import 'package:tunes/widgets/dialog_box.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlistModel;
  final Function(int) onDeletePlaylistButtonPressed;
  final onAddSongsButtonPressed;

  const PlaylistCard({
    Key? key,
    required this.playlistModel,
    required this.onDeletePlaylistButtonPressed,
    required this.onAddSongsButtonPressed,
  }) : super(key: key);

  _buildOptionButtons(String label, IconData icon, Function onTap) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        ),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: textColor.withOpacity(0.4), width: 1),
          ),
        ),
      ),
      onPressed: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Icon(icon, color: textColor),
        ],
      ),
    );
  }

  _showPlaylistOptionsDialog(context) {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogBox(
          title: playlistModel.playlist,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOptionButtons(
                "Add songs",
                Icons.add,
                () {
                  Navigator.pop(context);
                  onAddSongsButtonPressed();
                },
              ),
              const SizedBox(height: 8.0),
              _buildOptionButtons(
                "Delete playlist",
                Icons.delete_forever_rounded,
                () {
                  onDeletePlaylistButtonPressed(playlistModel.id);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => _showPlaylistOptionsDialog(context),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlaylistDetailScreen(playlistModel: playlistModel),
          ),
        );
      },
      child: DefaultTextStyle(
        style: const TextStyle(
          color: textColor,
          fontSize: 18,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlistModel.playlist,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "${playlistModel.numOfSongs}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: textColor.withOpacity(0.6),
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
