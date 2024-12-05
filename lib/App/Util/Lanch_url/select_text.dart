import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InteractiveTextScreen extends StatelessWidget {
  final String description;

  const InteractiveTextScreen({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      _buildTextSpan(
          """S+6 + App inventory Besoins : - Production : N°lot auto incrément (Dans la liste Backlog). - lecture du Code à barre des lots lors de la création d'un BL (Besoin existe déjà) - Droit de timbre modifiable(a discuter avec le client ) - Raccourci de Matière première dans la liste des produits (Requête SQL) -Accès total dans la modifications des modèles d'impression avec DevExpress (Offerte au Client) N Telhttps://cri.hisbaerp.com/dashboard/missions  Monsieur Smara 0552316740 Localisation GPS : https://maps.app.goo.gl/YFQcwK4aEcE5rhh16 Net a payer : 608 326.81 TTC Montant du Chèque : 608 326.81 DA""",
          context),
    );
  }

  TextSpan _buildTextSpan(String text, BuildContext context) {
    final phoneRegExp =
        RegExp(r'\b(05|06|07)\d{8}\b'); // Matches Algerian phone numbers
    final urlRegExp = RegExp(r'https?://[^\s]+'); // Matches URLs

    List<InlineSpan> spans = [];
    text.splitMapJoin(
      RegExp('${phoneRegExp.pattern}|${urlRegExp.pattern}'),
      onMatch: (Match match) {
        final matchText = match.group(0)!;
        if (phoneRegExp.hasMatch(matchText)) {
          // Phone number
          spans.add(
            TextSpan(
              text: matchText,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri phoneUri = Uri(scheme: 'tel', path: matchText);
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    await launchUrl(phoneUri);
                  }
                },
            ),
          );
        } else if (urlRegExp.hasMatch(matchText)) {
          // URL
          spans.add(
            TextSpan(
              text: matchText,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url = Uri.parse(matchText);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                    );
                  } else {
                    await launchUrl(
                      url,
                    );
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('Could not open $matchText')),
                    // );
                  }
                },
            ),
          );
        }
        return matchText;
      },
      onNonMatch: (nonMatch) {
        spans.add(TextSpan(text: nonMatch));
        return nonMatch;
      },
    );

    return TextSpan(
      style: TextStyle(color: Colors.grey[700]),
      children: spans,
    );
  }
}
