import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = "https://zenquotes.io/api/today";

Future<QuoteModel> fetchQuote() async {
  final prefs = await SharedPreferences.getInstance();
  QuoteModel? quote;

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      await prefs.setString('quote', jsonEncode(jsonData[0]));
      quote = QuoteModel.fromJson(jsonData[0]);
    }
  } on SocketException catch (_) {
    var storedQuote = prefs.getString('quote');
    quote = QuoteModel.fromJson(jsonDecode(storedQuote ?? ''));
  }

  return quote!;
}

class QuoteModel {
  final String quote;
  final String author;
  final String html;

  const QuoteModel({
    required this.quote,
    required this.author,
    this.html = '',
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(quote: json['q'], author: json['a'], html: json['h']);
  }
}

class Quote extends StatefulWidget {
  const Quote({Key? key}) : super(key: key);

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote>
    with AutomaticKeepAliveClientMixin<Quote> {
  late Future<QuoteModel> _quote;

  @override
  void initState() {
    _quote = fetchQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<QuoteModel>(
        future: _quote,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Stack(
                children: [
                  Positioned(
                    top: -1,
                    left: 16,
                    child: Image.asset('assets/images/quote.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          snapshot.data!.quote,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '- ${snapshot.data!.author}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const Divider(
                          color: Colors.white60,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  @override
  bool get wantKeepAlive => true;
}
