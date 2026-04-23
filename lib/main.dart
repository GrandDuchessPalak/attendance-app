import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevOps Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const DashboardScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('DevOps Attendance Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 80, color: Colors.blue),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login successful!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: ${e.toString()}')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account created! You can now login.')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registration failed: ${e.toString()}')),
                    );
                  }
                }
              },
              child: const Text('Create New Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showAttendanceDetails(BuildContext context, int attendedDays, int totalDays) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attendance Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Classes Attended: $attendedDays'),
            Text('Total Classes: $totalDays'),
            Text('Attendance Percentage: ${((attendedDays / totalDays) * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 16),
            const Text('Session-wise breakdown:'),
            const Text('• Theory: In progress'),
            const Text('• Practical: In progress'),
            const Text('• Assignments: Submitted'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAssignmentsDialog(BuildContext context, String userId, String userEmail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assignment Submissions'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Assignment 1
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('assignments')
                    .doc('${userId}_assignment1')
                    .snapshots(),
                builder: (context, snapshot) {
                  bool isSubmitted = snapshot.hasData && snapshot.data!.exists && snapshot.data!['submitted'] == true;
                  return ListTile(
                    leading: Icon(
                      isSubmitted ? Icons.check_circle : Icons.pending,
                      color: isSubmitted ? Colors.green : Colors.orange,
                    ),
                    title: const Text('Assignment 1'),
                    subtitle: Text(isSubmitted ? 'Submitted' : 'Pending'),
                    trailing: ElevatedButton(
                      onPressed: isSubmitted ? null : () async {
                        await FirebaseFirestore.instance
                            .collection('assignments')
                            .doc('${userId}_assignment1')
                            .set({
                          'userId': userId,
                          'userEmail': userEmail,
                          'assignmentId': 'assignment1',
                          'submitted': true,
                          'submittedAt': FieldValue.serverTimestamp(),
                          'fileUrl': 'https://drive.google.com/your-file-link',
                        });
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Assignment 1 Submitted!')),
                          );
                        }
                      },
                      child: Text(isSubmitted ? 'Submitted' : 'Submit'),
                    ),
                  );
                },
              ),
              const Divider(),
              // Assignment 2
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('assignments')
                    .doc('${userId}_assignment2')
                    .snapshots(),
                builder: (context, snapshot) {
                  bool isSubmitted = snapshot.hasData && snapshot.data!.exists && snapshot.data!['submitted'] == true;
                  return ListTile(
                    leading: Icon(
                      isSubmitted ? Icons.check_circle : Icons.pending,
                      color: isSubmitted ? Colors.green : Colors.orange,
                    ),
                    title: const Text('Assignment 2'),
                    subtitle: Text(isSubmitted ? 'Submitted' : 'Pending'),
                    trailing: ElevatedButton(
                      onPressed: isSubmitted ? null : () async {
                        await FirebaseFirestore.instance
                            .collection('assignments')
                            .doc('${userId}_assignment2')
                            .set({
                          'userId': userId,
                          'userEmail': userEmail,
                          'assignmentId': 'assignment2',
                          'submitted': true,
                          'submittedAt': FieldValue.serverTimestamp(),
                          'fileUrl': 'https://drive.google.com/your-file-link',
                        });
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Assignment 2 Submitted!')),
                          );
                        }
                      },
                      child: Text(isSubmitted ? 'Submitted' : 'Submit'),
                    ),
                  );
                },
              ),
              const Divider(),
              // Assignment 3
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('assignments')
                    .doc('${userId}_assignment3')
                    .snapshots(),
                builder: (context, snapshot) {
                  bool isSubmitted = snapshot.hasData && snapshot.data!.exists && snapshot.data!['submitted'] == true;
                  return ListTile(
                    leading: Icon(
                      isSubmitted ? Icons.check_circle : Icons.pending,
                      color: isSubmitted ? Colors.green : Colors.orange,
                    ),
                    title: const Text('Assignment 3'),
                    subtitle: Text(isSubmitted ? 'Submitted' : 'Pending'),
                    trailing: ElevatedButton(
                      onPressed: isSubmitted ? null : () async {
                        await FirebaseFirestore.instance
                            .collection('assignments')
                            .doc('${userId}_assignment3')
                            .set({
                          'userId': userId,
                          'userEmail': userEmail,
                          'assignmentId': 'assignment3',
                          'submitted': true,
                          'submittedAt': FieldValue.serverTimestamp(),
                          'fileUrl': 'https://drive.google.com/your-file-link',
                        });
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Assignment 3 Submitted!')),
                          );
                        }
                      },
                      child: Text(isSubmitted ? 'Submitted' : 'Submit'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Note: Click Submit to mark assignment as completed. Add your file link in the code.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMarksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mid / End Sem Marks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ListTile(
              title: Text('Mid Term Marks'),
              trailing: Text('24 / 30'),
            ),
            ListTile(
              title: Text('End Sem Marks'),
              trailing: Text('— / 60'),
            ),
            ListTile(
              title: Text('Practical Marks'),
              trailing: Text('— / 15'),
            ),
            ListTile(
              title: Text('CAP Marks'),
              trailing: Text('— / 10'),
            ),
            Divider(),
            ListTile(
              title: Text('Total Marks', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text('24 / 115', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, String userId, String userEmail) {
    final TextEditingController feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Comments / Suggestion / Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share your suggestion here. Max 50 words.'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                hintText: 'Type your feedback here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              maxLength: 500,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (feedbackController.text.trim().isNotEmpty) {
                await FirebaseFirestore.instance.collection('feedbacks').add({
                  'userId': userId,
                  'userEmail': userEmail,
                  'feedback': feedbackController.text.trim(),
                  'timestamp': FieldValue.serverTimestamp(),
                  'status': 'unread',
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for your feedback!')),
                  );
                }
              }
            },
            child: const Text('Submit Feedback'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My DevOps Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email?.split('@').first ?? 'Student',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assignments'),
              onTap: () {
                Navigator.pop(context);
                if (user != null) {
                  _showAssignmentsDialog(context, user.uid, user.email ?? '');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.grade),
              title: const Text('Marks'),
              onTap: () {
                Navigator.pop(context);
                _showMarksDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback / Suggestion'),
              onTap: () {
                Navigator.pop(context);
                if (user != null) {
                  _showFeedbackDialog(context, user.uid, user.email ?? '');
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email?.split('@').first ?? 'Student Name',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Enrollment: ${user?.uid.substring(0, 12) ?? '09701032024'}'),
                    const Text('Branch: IT2 | Sem: 4'),
                    const Row(
                      children: [
                        Text('Proxy Flag: '),
                        Icon(Icons.check_box_outline_blank, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Attendance Progress Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attendance Progress',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('attendance')
                          .where('userId', isEqualTo: user?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        int totalDays = 12;
                        int attendedDays = snapshot.hasData ? snapshot.data!.docs.length : 0;
                        double percentage = (attendedDays / totalDays) * 100;
                        
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Overall Attendance'),
                                Text('$attendedDays / $totalDays Days'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: attendedDays / totalDays,
                              backgroundColor: Colors.grey[300],
                              color: percentage >= 75 ? Colors.green : Colors.orange,
                              minHeight: 10,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: percentage >= 75 ? Colors.green : Colors.orange,
                              ),
                            ),
                            Text('Includes old class attendance = $attendedDays'),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _showAttendanceDetails(context, attendedDays, totalDays);
                              },
                              child: const Text('View Details'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Mark Attendance Button
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('attendance').add({
                  'userId': user?.uid,
                  'email': user?.email,
                  'timestamp': FieldValue.serverTimestamp(),
                  'status': 'present',
                  'date': DateTime.now().toIso8601String(),
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Attendance Marked for Today!')),
                  );
                }
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Mark Today\'s Attendance'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}