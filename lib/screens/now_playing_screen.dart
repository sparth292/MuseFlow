import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with down arrow and options
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Now Playing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Album art
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(32),
                      aspect: 1.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage('https://example.com/album_art.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Song info with marquee
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            child: Marquee(
                              text: 'Timeless (feat. Playboi Carti)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 20.0,
                              velocity: 30.0,
                              pauseAfterRound: Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: Duration(seconds: 1),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'The Weeknd',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Player controls
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          // Progress bar
                          SliderTheme(
                            data: SliderThemeData(
                              thumbColor: Colors.cyan,
                              activeTrackColor: Colors.cyan,
                              inactiveTrackColor: Colors.grey[800],
                              trackHeight: 2,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                            ),
                            child: Slider(
                              value: 0.5,
                              onChanged: (value) {},
                            ),
                          ),
                          // Time indicators
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '2:15',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  '4:30',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          // Control buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.shuffle, color: Colors.white),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.skip_previous, color: Colors.white, size: 36),
                                onPressed: () {},
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.cyan,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.pause, color: Colors.black, size: 36),
                                  onPressed: () {},
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.skip_next, color: Colors.white, size: 36),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.repeat, color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Lyrics section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lyrics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'I feel it coming, baby (Yeah)\nI feel it coming, baby (Oh)\nI feel it coming, baby (Coming)\nI feel it coming, baby',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 