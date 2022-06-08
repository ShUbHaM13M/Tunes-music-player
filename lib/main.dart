import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/screens/home/home_screen.dart';
import 'package:tunes/utils/provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await JustAudioBackground.init(
    androidNotificationChannelId: "com.shubh.tunes",
    androidNotificationChannelName: "Audio Playback",
    androidNotificationOngoing: true,
  ).then((_) => FlutterNativeSplash.remove());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() async {
    if (await _audioQuery.permissionsRequest()) {
      var songs = await _audioQuery.querySongs();
      var filteredSongs = songs.where((song) => song.isMusic!).toList();
      ref.read(songListProvider.notifier).state = filteredSongs;
      loadSongs(filteredSongs);
    }
  }

  //? TODO: Changing the app logo

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
