import 'package:flutter/material.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class CommunityGuidelinesPage extends StatelessWidget {
  const CommunityGuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundTile(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: "Community Guidelines",
              theme: "purple",
              showBackButton: false,
              fixRight: false,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Welcome to Snippets!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: styling.backgroundText,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Our mission is to create a positive and welcoming space where everyone can share, connect, and grow. By using Snippets, you agree to follow these simple guidelines to help maintain a supportive and respectful community.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: styling.backgroundText),
                ),
                SizedBox(height: 24),
                _buildGuidelineSection(
                  '1. Be Kind and Respectful',
                  [
                    'Treat everyone with kindness and respect, just as you’d like to be treated.',
                    'Celebrate differences and embrace diversity.',
                  ],
                ),
                _buildGuidelineSection(
                  '2. No Bullying or Harassment',
                  [
                    'Bullying, harassment, or intimidation of any kind will not be tolerated.',
                    'Avoid targeting individuals or groups with harmful or negative messages.',
                  ],
                ),
                _buildGuidelineSection(
                  '3. Use Inclusive and Respectful Language',
                  [
                    'Use language that promotes understanding and kindness.',
                    'Hate speech, slurs, or any messages that promote intolerance are strictly prohibited.',
                  ],
                ),
                _buildGuidelineSection(
                  '4. Think Before You Answer a Snippet or send a Message',
                  [
                    'Ensure your responses or messages add value to the conversation and reflect positivity.',
                    'If you wouldn’t say it face-to-face, don’t send it as an answer or message.',
                  ],
                ),
                _buildGuidelineSection(
                  '5. Report and Support',
                  [
                    'If you encounter inappropriate behavior or messages, report them so we can take action.',
                    'Support others by fostering uplifting and encouraging interactions.',
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'By following these guidelines, we can work together to make Snippets a safe and welcoming space for everyone. Thank you for helping us build a positive community!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: styling.backgroundText),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      await HelperFunctions.saveAcceptedCommunityGuidelinesSF(
                          true);
                      Navigator.pop(context);
                    },
                    style: styling.elevatedButtonDecoration(),
                    child:
                        Text('Accept', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelineSection(String title, List<String> bulletPoints) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: styling.backgroundText,
            ),
          ),
          SizedBox(height: 8),
          ...bulletPoints.map((point) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style:
                        TextStyle(fontSize: 16, color: styling.backgroundText),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16, color: styling.backgroundText),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
