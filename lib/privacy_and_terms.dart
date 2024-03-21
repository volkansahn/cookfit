import 'package:flutter/material.dart';

class PrivacyAndTermsPage extends StatelessWidget {
  const PrivacyAndTermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy % Terms'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Effective Date: March 11, 2024\nThank you for choosing Cookfit. This Privacy Policy describes how Cookfit ("we," "us," or "our") collects, uses, and discloses your information when you use our mobile application (the "App"). By accessing or using the App, you agree to the terms of this Privacy Policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1. Information We Collect',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'When you use our App, we may collect the following information:',
              style: TextStyle(fontSize: 16),
            ),
            BulletList([
              'Email Address: We collect your email address when you sign up for an account in order to provide you with access to our services and to communicate with you.',
              'Analytics Data: We use Google Analytics and App Store Analytics to collect information about your use of the App, such as session duration, pages visited, and interactions. This helps us understand how users interact with our App and improve our services.',
              'Advertising: We may display advertisements in the App served by Google Ads. These ads may be targeted based on your interests or other information collected about you over time and across different websites and online services using cookies.',
              'Payment Information: If you choose to subscribe to premium features within the App, your payment will be processed through Google or Apple payment platforms. We do not store your payment information on our servers.',
            ]),
            Text(
              '2. How We Use Your Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'When you use our App, we may collect the following information:',
              style: TextStyle(fontSize: 16),
            ),
            BulletList([
              'To provide, maintain, and improve the App and our services.',
              'To communicate with you, including responding to your inquiries and providing customer support.',
              'To personalize your experience and content within the App.',
              'To analyze trends, administer the App, and gather demographic information.',
              'To comply with legal obligations and protect our rights.'
            ]),
            Text(
              '3. Information Sharing',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'We may share your information with third parties in the following circumstances:',
              style: TextStyle(fontSize: 16),
            ),
            BulletList([
              'With service providers who assist us in operating the App and providing our services, such as hosting providers, analytics providers, and payment processors.',
              'With advertisers and advertising networks to display relevant advertisements in the App.',
              'In response to a legal request or to comply with applicable laws, regulations, or legal processes.',
              'In connection with a merger, acquisition, or sale of assets.'
            ]),
            Text(
              '4. Your Choices',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            BulletList([
              'Email Communications: You may opt-out of receiving promotional emails from us by following the instructions in those emails. However, we may still send you non-promotional communications, such as service-related emails.',
              'Cookies: You can usually choose to set your browser to remove or reject browser cookies. Please note that if you choose to disable cookies, some parts of the App may not function properly.'
            ]),
            Text(
              '5. Contact Us',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'If you have any questions or concerns about this Privacy Policy or our data practices, you may contact us at vsahin0985@gmail.com.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '6. Children\'s Privacy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'The App is not intended for users under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe that your child has provided us with personal information, please contact us so that we can take appropriate action.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '7. Changes to this Privacy Policy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'We may update this Privacy Policy from time to time. If we make any material changes, we will notify you by posting the updated Privacy Policy on this page with a new effective date.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Terms of Use for Cookfit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Effective Date: March 11, 2024\nWelcome to Cookfit! These Terms of Use ("Terms") govern your access to and use of the Cookfit mobile application (the "App"), operated by [Your Name] ("we," "us," or "our"). By accessing or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1. Use of the App',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'You may use the App only for your personal, non-commercial purposes. You agree not to:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            BulletList([
              'Use the App in any way that violates any applicable laws or regulations.',
              'Attempt to interfere with the proper functioning of the App.',
              'Reverse engineer, decompile, or disassemble any part of the App.',
              'Use the App to transmit any harmful code or malware.',
              'Use the App to collect personal information from other users without their consent.',
            ]),
            SizedBox(height: 20),
            Text(
              '2. Account Registration',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'In order to access certain features of the App, you may be required to create an account. When you create an account, you agree to provide accurate and complete information and to keep your login credentials secure. You are responsible for all activity that occurs under your account.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. Intellectual Property',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'The App and its content, including text, graphics, logos, and images, are owned by CookFit or its licensors and are protected by copyright and other intellectual property laws. You may not reproduce, distribute, modify, or create derivative works of the App or its content without our prior written consent.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '4. Intellectual Property',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'The App may contain links to third-party websites or services that are not owned or controlled by CookFit. We are not responsible for the content or privacy practices of these third-party sites. Your use of third-party websites or services is at your own risk.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '5. Disclaimer of Warranties',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '6. Limitation of Liability',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'IN NO EVENT SHALL [YOUR NAME] OR ITS AFFILIATES, OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, ARISING OUT OF OR IN CONNECTION WITH YOUR USE OF THE APP, WHETHER BASED ON WARRANTY, CONTRACT, TORT (INCLUDING NEGLIGENCE), OR ANY OTHER LEGAL THEORY, EVEN IF [YOUR NAME] HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '7. Governing Law',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'These Terms shall be governed by and construed in accordance with the laws of Turkey, without regard to its conflict of law principles.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '8. Changes to these Terms',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'We may update these Terms from time to time. If we make any material changes, we will notify you by posting the updated Terms on this page with a new effective date.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '9. Contact Us',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'If you have any questions or concerns about these Terms, you may contact us at vsahin0985@gmail.com.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'By using the App, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> strings;

  BulletList(this.strings);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(16, 15, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u2022',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.55,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    str,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6),
                      height: 1.55,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
