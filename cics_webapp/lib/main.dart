import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CICS Web App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _officersScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _officersScrollController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: _buildAppBarTitle(),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Image.asset(
                'assets/CICS_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                _tabController.animateTo(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Announcements'),
              onTap: () {
                _tabController.animateTo(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Officers'),
              onTap: () {
                _tabController.animateTo(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                _tabController.animateTo(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_tabController.index == 0)
            Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome to the College of Informatics and Computing Sciences',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 300.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: carouselImages.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Image.asset(image, fit: BoxFit.cover);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const HomeTab(),
                AnnouncementsTab(
                  announcements: announcements,
                  scrollController: _scrollController,
                ),
                OfficersTab(
                  scrollController: _officersScrollController,
                ),
                const AboutUsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(10),
        child: const Text(
          '© 2024 College of Informatics and Computing Sciences',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    switch (_tabController.index) {
      case 0:
        return const Text('Home');
      case 1:
        return const Text('Announcements');
      case 2:
        return const Text('Officers');
      case 3:
        return const Text('About Us');
      default:
        return const Text('CICS Web App');
    }
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Container(
        color: Colors.white.withOpacity(0.8),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/CICS_logo.png', width: 300, height: 300),
          ],
        ),
      ),
    );
  }
}

class AnnouncementsTab extends StatelessWidget {
  final List<Map<String, String>> announcements;
  final ScrollController scrollController;

  const AnnouncementsTab({
    super.key,
    required this.announcements,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  return AnnouncementCard(announcement: announcements[index]);
                },
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  child: const Icon(Icons.arrow_upward),
                  onPressed: () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Stack(
            children: [
              GridView.builder(
                controller: scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  return AnnouncementCard(announcement: announcements[index]);
                },
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  child: const Icon(Icons.arrow_upward),
                  onPressed: () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Map<String, String> announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(announcement['title']!),
                content: Text(announcement['content']!),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              announcement['image']!,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Click to view details',
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfficersTab extends StatelessWidget {
  final ScrollController scrollController;

  const OfficersTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            if (constraints.maxWidth < 600)
              GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: officers.length,
                itemBuilder: (context, index) {
                  return OfficerCard(officer: officers[index]);
                },
              )
            else
              GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: officers.length,
                itemBuilder: (context, index) {
                  return OfficerCard(officer: officers[index]);
                },
              ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                child: const Icon(Icons.arrow_upward),
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class OfficerCard extends StatelessWidget {
  final Map<String, String> officer;

  const OfficerCard({super.key, required this.officer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(officer['name']!),
                content: Text(officer['details']!),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
              message: 'Click for details',
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(officer['photo']!),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              officer['name']!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              officer['position']!,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsTab extends StatelessWidget {
  const AboutUsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 15),
          const Text(description),
          const SizedBox(height: 40),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          ...faqs.map((faq) => FAQItem(faq: faq)),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final Map<String, String> faq;

  const FAQItem({super.key, required this.faq});

  @override
  // ignore: library_private_types_in_public_api
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
        title: Text(widget.faq['question']!),
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.faq['answer']!),
          ),
        ],
      ),
    );
  }
}

const List<String> carouselImages = [
  'assets/images/carousel1.jpg',
  'assets/images/carousel2.jpg',
  'assets/images/carousel3.jpg',
  'assets/images/carousel4.jpg',
  'assets/images/carousel5.jpg',
  'assets/images/carousel6.jpg',
  'assets/images/carousel7.jpg',
];

const List<Map<String, String>> announcements = [
  {
    'title':
        'FEBRUARY 22, 2024 \nRecap of the meeting about Data App with Third year BSIT Students from BSU Alangilan ',
    'image': 'assets/images/carousel5.jpg',
    'content':
        '     On Thursday, February 22, 2024, at 4:06 PM, the office of the Action Center hosted a meeting with Dr. Nickie Manalo and Third-year BSIT students from the College of Informatics and Computing Sciences at Batangas State University, Alangilan Campus. The focal point of the discussion centered around a capstone project proposal concerning the implementation of a data app. \n\n     The meeting marked a significant milestone in the initiation of an innovative application tailored specifically to meet the requirements of the Office of Action Center. Emphasizing tangible usability and multi-domain functionality, the aim is to develop a transformative tool that caters to the diverse needs of the BSU community and extends its benefits beyond campus borders. \n\n     Through collaboration and strategic planning, there is a commitment to delivering an application that not only meets objectives but also fosters engagement and empowerment among students and stakeholders. As the project moves forward, there is anticipation for the collective effort and creativity that will shape this initiative into a valuable asset for the communit!'
  },
  {
    'title': 'OUR EVER-UPWARD EXCELLENC',
    'image': 'assets/images/SINAG.PNG',
    'content':
        '     Testament to what we have accomplished together as a student organization throughout the year. It is truly remarkable to see the milestones we have reached and the challenges we overcame. Our collective efforts have not only enriched our campus’ community but also strengthened our sense of purpose and camaraderie. From organizing impactful events to initiating meaningful projects, every achievement is a reflection of our dedication, collaboration, and relentless pursuit of excellence. As we look ahead, let us continue to build on this momentum, striving for even greater heights and setting new benchmarks for success. Together, we have proven that there is no limit to what we can achieve as a united and passionate student body dedicated to service. \n\n     Embodying the Ever-Upward spirit, constantly breaking barriers and reaching new heights! \n\n     #EverUpward\n     #ExcelCICSior'
  },
  {
    'title':
        'ACICStance Corner: Student Service Projects bags the Student Activity of the Year for Student Welfare.',
    'image': 'assets/images/ACICS.PNG',
    'content':
        'Here to assist you! \n\n      Another year has passed, and we want to commend everyone for a successul academic year. The efforts of every CICSmars have truly paid off. \n\n     The College of Informatics and Computing Sciences proudly presents to you the activities and programs that showcase the skills and talent of every student from our department. Together, we continue striving ever upward.\n     #EverUpward \n     #ExcelCICSior'
  },
  {
    'title': 'Samsung Galaxy Campus Batch 2 Student Ambassador',
    'image': 'assets/images/carousel2.jpg',
    'content':
        'Congratulations to our very own Committee Head on Academic Affairs, Aeron Evangelista, for being chosen as one of the only two students from Batangas State University - TNEU for the Galaxy Campus Student Ambassador Batch 2! \n\nAs you embark on this exciting journey with Samsung, we are cheering you on every step of the way. We are looking forward to see you grow and  make remarkable achievements and contributions as a student ambassador.\n\nThe Samsung Galaxy Campus Batch 2 Student Ambassador has a total of 6611 applicants, wherein were 189 interviewed, and only 100 including Aeron were selected to be the official galaxy campus ambassadors.With that, we, your CICS Family are incredibly proud of you!\n\n#EverUpward\n#ExcelCICSior'
  },
  {
    'title': 'Batch Valedictorian, Samsung Galaxy Campus - Batch 1',
    'image': 'assets/images/Valedictorian.jpg',
    'content':
        'The College of Informatics and Computing Sciences Student Council Alangilan proudly congratulates our very own Committee Head on Academic Affairs, Iemerie Jom Manguit, as he finishes his Samsung Galaxy Campus Ambassador journey as the Valedictorian of its pioneer batch.\n\nAn ever-upward achievement, indeed. You’ve not only set a high standard for excellence but also inspired your peers to reach for the stars.\n\nCongratulations!\n\n#EverUpward\n#ExcelCICS10r'
  },
  {
    'title': '12th IT Skills Olympics Participants',
    'image': 'assets/images/ITSOlympics.jpg',
    'content':
        '𝗖𝗲𝗹𝗲𝗯𝗿𝗮𝘁𝗶𝗻𝗴 𝗘𝘅𝗰𝗲𝗹𝗹𝗲𝗻𝗰𝗲 𝗶𝗻 𝘁𝗵𝗲 𝟭𝟮𝘁𝗵 𝗜𝗧 𝗦𝗸𝗶𝗹𝗹𝘀 𝗢𝗹𝘆𝗺𝗽𝗶𝗰𝘀✨\n\nHats off to our brilliant representatives from the College of Informatics and Computing Sciences at the IT Skills Olympics!\n\nCongratulations to:\n𝗜𝗲𝗺𝗲𝗿𝗶𝗲 𝗝𝗼𝗺 𝗖𝘂𝘀𝘁𝗼𝗱𝗶𝗼 𝗠𝗮𝗻𝗴𝘂𝗶𝘁 - IT Quiz Bee\n𝗔𝗮𝗿𝗼𝗻 𝗝𝗼𝗵𝗻 𝗠𝘂𝗹𝗶𝗻𝘆𝗮𝘄𝗲 𝗦𝗮𝗵𝗮𝗴𝘂𝗻 - Webpage Design\n𝗟𝗮𝗻𝗰𝗲 𝗗𝗮𝗻𝗶𝗲𝗹 𝗠𝗮𝘀𝗶𝗹𝗮𝗻𝗴 𝗖𝗿𝗶𝘀𝗮𝗻𝗴 - .NET Programming (C#)\n𝗔𝘂𝗴𝘂𝘀𝘁𝗶𝗻 𝗖𝗵𝗿𝗶𝘀𝘁𝗶𝗮𝗻 𝗙𝗹𝗼𝗿𝗲𝘀 𝗱𝗲 𝗹𝗮 𝗣𝗲ñ𝗮 - .NET Programming (C#)\n𝗞𝗮𝗿𝗹 𝗝𝗼𝘀𝗲𝗽𝗵 𝗔𝗹𝗺𝗼𝗻𝘁𝗲 𝗔𝗴𝘂𝗶𝗹𝗮𝗿 - Java Programming\n𝗖𝗼𝗹𝘁 𝗔𝘂𝗿𝗼𝗻 𝗚𝗮𝗺𝗼 𝗧𝗮𝗻 - Java Programming\n𝗝𝗼𝗻 𝗘𝗻𝗱𝗿𝗶𝗰𝗸 𝗠𝗼𝗻𝘁𝗼𝘆𝗮 𝗕𝗮𝗯𝗮𝗼 - Android Application Development (Game Development)\n𝗠𝗮𝗿𝗶𝘂𝘀 𝗝𝗮𝗰𝗼𝗯 𝗦𝗮𝗿𝘁𝗲 𝗛𝗲𝗿𝗻𝗮𝗻𝗱𝗲𝘇 - Android Application Development (Game Development)\n𝗩𝗹𝗮𝗱𝗶𝗺𝗶𝗿 𝗠𝗮𝗴𝘀𝗶𝗻𝗼 𝗝𝗼𝗰𝘀𝗼𝗻 - Android Application Development (Game Development)\n𝗝𝗵𝗲𝗻𝗿𝗲𝘆 𝗔. 𝗔𝘀𝗶𝘀 - E-games (Mobile Legends: Bang Bang)\n𝗝𝗼𝘀𝗵𝘂𝗮 𝗘𝘀𝗰𝗮𝗹𝗼𝗻𝗮 𝗕𝗿𝗮𝘇𝗮 - E-games (Mobile Legends: Bang Bang)\n𝗣𝗿𝗲𝗯𝗲𝗻 𝗠𝗮𝗿𝘁𝗶𝗻 𝗚𝗮𝗿𝗰𝗶𝗮 - E-games (Mobile Legends: Bang Bang)\n𝗝𝗮𝗺𝗲𝘀 𝗣𝗮𝘁𝗿𝗶𝗰𝗸 𝗣𝗼𝗯𝗮𝗱𝗼𝗿𝗮 𝗡𝗮𝘁𝗮𝗻𝗮𝘂𝗮𝗻 - E-games (Mobile Legends: Bang Bang)\n𝗝𝗼𝗵𝗻 𝗘𝗱𝘄𝗮𝗿𝗱 𝗩𝗶𝘃𝗮𝘀 𝗥𝗲𝘆𝗲𝘀 - E-games (Mobile Legends: Bang Bang)\n\nYour dedication, skills, and sportsmanship have brought glory to our college! We, the CICS Student Council, are proud of you!💙🤍\n\n#EverUpward\n#ExcelCICS10r'
  },
  {
    'title': 'CYBERFEST is Happening Now!',
    'image': 'assets/images/cyberfest.jpg',
    'content':
        'Join us in real-time as we dive into the future of innovation. From mind-bending documentaries to the fusion of art and math, electrifying seminars, groundbreaking pitches, and cutting-edge capstone presentations – its all unfolding before our eyes! \n\nDont miss the moment, CICSians!\n\n#CYBERFEST\n#EverUpward\n#ExcelCICS10r'
  },
  {
    'title': '3RD PLACE, Caputre the Essence: Digital Photography Competition',
    'image': 'assets/images/CTE.jpg',
    'content':
        'Capturing the Essence of Excellence\n\nMikaella Ebora, a 2nd-year BS Computer Science student, snagged 3rd place in the "Capture the Essence: Digital Photography Competition.\n\nHer inspiring photo, aligned with the theme "Empowering Educators: Strengthening Resilience, Building Sustainability," beautifully exemplifies the spirit of World Teachers Day 2023.\n\nYour exceptional achievement underscore the ethos of excellence within our college, transcending virtual dimensions. We are proud of you!\n\nCongratulations!\n\n#EverUpward\n#ExcelCICSior'
  },
  {
    'title': 'CICSians by the Seashore',
    'image': 'assets/images/Seashore.jpg',
    'content':
        'Shining in the sun, covering the shore 🌊\n\nAs we wander the vast universe, the College of Informatics and Computing Sciences shall take you deep in the oceans in our TAKE OFF 2023: Wander the Vast UNIVERSE Booth: CICSians by the Seashore!\n\nCatch us at the campus student orientation program on August 17, 2023, Thursday, at the Fitness Development Center, and get a chance to win exciting prizes.\n\nSee you there, under-the-sea wanderers!\n\n#TAKEOFF2023\n#EverUpward\n#ExcelCICSior'
  },
  {
    'title': 'CICS Alangilan - Student Council - Awardees',
    'image': 'assets/images/achievement.jpg',
    'content':
        'The Supreme Student Council Alangilan recently held the SINAG Awards 2024 to recognize the students who showed exemplary leadership skills and community service. Another Ever-Upward Recognition for our dedicated and brilliant students who achieved this award as well as to the CICS Student Council!\n\n𝐂𝐨𝐥𝐥𝐞𝐠𝐞 𝐨𝐟 𝐈𝐧𝐟𝐨𝐫𝐦𝐚𝐭𝐢𝐜𝐬 𝐚𝐧𝐝 𝐂𝐨𝐦𝐩𝐮𝐭𝐢𝐧𝐠 𝐒𝐜𝐢𝐞𝐧𝐜𝐞𝐬\n🏆One of the Ten Outstanding Student Organizations of the Year 2023-2024\n🏆ACICStance Corner -Awardee for Student Activity of the Year for Student Welfare\n🏆TECHNOFUSION 2024: Reimagine Tomorrow - Finalist for Student Activity of the Year for Academic Excellence\n\n𝐋𝐞𝐧 𝐀𝐮𝐛𝐫𝐞𝐲 𝐂𝐚𝐧𝐭𝐨𝐬\n🏅Ten Outstanding Student Awards, Rank 7\n🏅Council of Organization Presidents Service Awardee\n🏅Supreme Student Council - Alangilan Service Awardee\n\n𝐀𝐞𝐫𝐨𝐥𝐥𝐞 𝐓. 𝐒𝐚𝐧𝐚\n🏅Ten Outstanding Student Award, Rank 1\n🏆Service Awardee - Supreme Student Council BatStateU The NEU Alangilan (Committee Chairperson, Technical Affairs)\n🏆SINAG Leadership Award of Excellence\n\n𝐉𝐡𝐨𝐦𝐚𝐫𝐢 𝐑𝐚𝐦𝐢𝐫𝐞𝐳\n\n🏆Campus Leadership: Ilang-Ilang Recognition of Exceptional Leadership \n🎖Supreme Student Council Service Awardee\n🎖Council of Organization Presidents Service Awardee \n\n𝐇𝐚𝐧𝐧𝐚𝐡 𝐉𝐨𝐬𝐞\n🎖Council of Organization Presidents Service Awardee \n\n𝐉𝐚𝐧 𝐄𝐥𝐥𝐚 𝐕𝐢𝐥𝐥𝐨𝐭𝐚\n🎖Council of Organization Presidents Service Awardee \n\n𝐈𝐞𝐦𝐞𝐫𝐢𝐞 𝐉𝐨𝐦 𝐌𝐚𝐧𝐠𝐮𝐢𝐭\n🏆 Youth Leadership Excellence for Engineering and Technology\n\n𝐑𝐚𝐥𝐩𝐡 𝐌𝐚𝐭𝐭𝐡𝐞𝐰 𝐒𝐚𝐧𝐠𝐠𝐚𝐥𝐚𝐧𝐠\n🏅Ten Outstanding Student Awards, Rank 6\n🏅Supreme Student Council - Alangilan Service Awardee\n🏆 Ilang Ilang Recognition Of Exceptional Leadership\n\nCongratulations to all SINAG Awardees! Your dedication, hardwork, and passion have set a remarkable example for all of us. Continue to shine brightly and may your journey be filled with endless opportunities and success. \n\nMore power and achievements to the College of Informatics and Computing Sciences! \n\n#EverUpward\n#ExcelCICSior'
  },
  {
    'title':
        '𝗘𝗺𝗽𝗼𝘄𝗲𝗿𝗺𝗲𝗻𝘁 𝗦𝘁𝗮𝗿𝘁𝘀 𝘄𝗶𝘁𝗵 𝗘𝘅𝗽𝗿𝗲𝘀𝘀𝗶𝗼𝗻',
    'image': 'assets/images/concerns.jpg',
    'content':
        'We aim to create a streamlined and efficient channel for students to voice their grievances and seek assistance for a wide range of academic and non-academic issues. We are committed to listening and taking actionable steps to bring about positive change within our community.\n\nYour voice matters, we are here to listen, respond, and transform.\n\nAccess the CICS Student Grievance and Welfare form through this link: bit.ly/ProjectACTS_CICS\n\n#EverUpward\n#ExcelCICSior'
  },
  {
    'title': '𝗘𝗖𝗢 𝗦𝗨𝗠𝗠𝗜𝗧 𝟮𝟬𝟮𝟰',
    'image': 'assets/images/ECOSummit2024.jpg',
    'content':
        'The 𝗘𝗖𝗢 𝗦𝗨𝗠𝗠𝗜𝗧 𝟮𝟬𝟮𝟰 served as a beacon of hope and collaboration in the fight against plastic pollution, with passionate individuals and organizations coming together to address this critical issue. \n\nIn the heart of this impactful event, our BSCS 1201 students shone brightly, emerging victorious in 𝗿𝗘𝗖𝗢𝗻𝗳𝗶𝗴𝘂𝗿𝗲 (𝗦𝘂𝘀𝘁𝗮𝗶𝗻𝗮𝗯𝗹𝗲 𝗙𝗮𝘀𝗵𝗶𝗼𝗻 𝗜𝘁𝗲𝗺 𝗖𝗿𝗮𝗳𝘁𝗶𝗻𝗴 𝗖𝗼𝗺𝗽𝗲𝘁𝗶𝘁𝗶𝗼𝗻) with their brilliant creation bagging First Place. Congatulations, CICSians!  \n\nWe, the CICS Alangilan Student Council, could not be prouder of all the participants who showcased their dedication to combatting plastic pollution. Your creativity, passion, and commitment to sustainability are truly inspiring!\n\nThank you for representing our college with excellence and for contributing to the global movement for a cleaner, healthier planet. \n\n#ExcelCICSior\n#EverUpward'
  },
  {
    'title':
        '𝗦𝗲𝘁𝘁𝗶𝗻𝗴 𝘀𝗮𝗶𝗹 𝘁𝗼𝘄𝗮𝗿𝗱𝘀 𝘃𝗶𝗰𝘁𝗼𝗿𝘆 𝗮𝘁 𝗕𝗜𝗧𝗖𝗢𝗡!🏆',
    'image': 'assets/images/BitCon.jpg',
    'content':
        'The College of Informatics and Computing Sciences Alangilan Student Council congratulates 𝗩𝗹𝗮𝗱𝗶𝗺𝗶𝗿 𝗝𝗼𝗰𝘀𝗼𝗻, a 2nd-year BS Computer Science student, for clinching 𝟭𝘀𝘁 𝗣𝗹𝗮𝗰𝗲 in the 𝗝𝗮𝘃𝗮/𝗣𝘆𝘁𝗵𝗼𝗻 𝗣𝗿𝗼𝗴𝗿𝗮𝗺𝗺𝗶𝗻𝗴 𝗖𝗼𝗺𝗽𝗲𝘁𝗶𝘁𝗶𝗼𝗻 amidst the sea of talents at the 𝗕𝗮𝘁𝗮𝗻𝗴𝗮𝘀 𝗜𝗻𝗳𝗼𝗿𝗺𝗮𝘁𝗶𝗼𝗻 𝗧𝗲𝗰𝗵𝗻𝗼𝗹𝗼𝗴𝘆 𝗖𝗼𝗻𝗳𝗲𝗿𝗲𝗻𝗰𝗲 (𝗕𝗜𝗧𝗖𝗢𝗡), April 6.\n\nYour mastery in programming not only showcases your technical prowess but also embodies the spirit of integration, innovation, and security—the very essence of this years BITCON theme. As you navigate the future of technology, may your success inspire others to push boundaries and explore new horizons.\n\n#EverUpward\n#ExcelCICSior'
  },
  {
    'title': 'QUALIFIER: Ayala Youth Leader Congress',
    'image': 'assets/images/AYLC.jpg',
    'content':
        'With a blend of excitement and admiration, we congatulate 𝗜𝗲𝗺𝗲𝗿𝗶𝗲 𝗝𝗼𝗺 𝗠𝗮𝗻𝗴𝘂𝗶𝘁, and celebrate his remarkable achievement in qualifying for the online panel interviews at the esteemed 𝗔𝘆𝗮𝗹𝗮 𝗬𝗼𝘂𝘁𝗵 𝗟𝗲𝗮𝗱𝗲𝗿𝘀 𝗖𝗼𝗻𝗴𝗿𝗲𝘀𝘀 (𝗔𝗬𝗟𝗖).\n\nThis success is a reflection of your unwavering dedication, leadership potential, and commitment to effecting positive change. Your selection among the chosen few is a testament to your exemplary qualities and the promise you hold as a future leader in our society.\n\nGood luck with your online panel interview, and know that the 𝗖𝗼𝗹𝗹𝗲𝗴𝗲 𝗼𝗳 𝗜𝗻𝗳𝗼𝗿𝗺𝗮𝘁𝗶𝗰𝘀 𝗮𝗻𝗱 𝗖𝗼𝗺𝗽𝘂𝘁𝗶𝗻𝗴 𝗦𝗰𝗶𝗲𝗻𝗰𝗲𝘀 𝗔𝗹𝗮𝗻𝗴𝗶𝗹𝗮𝗻 𝗦𝘁𝘂𝗱𝗲𝗻𝘁 𝗖𝗼𝘂𝗻𝗰𝗶𝗹 stands with you, cheering you on every step of the way. We wish you resounding success!\n\n#EverUpward\n#ExcelCICSior'
  },
  {
    'title': ' TECHNOFUS10N 2024 : Reimagine Tomorrow',
    'image': 'assets/images/technofusion.jpg',
    'content':
        '𝕺𝕹𝕮𝕰 upon a time... in a world where dreams are born from the whispers of the heart, there lived a sorcerer who devoted himself to mastering the magic that could shield and nurture the future. And so, the sorcerer crafted a place of power, creating a realm where every skill, no matter its origin, was embraced. \n\nJoin us in unleashing the POWER you hold in TECHNOFUSION 2024: Reimagine Tomorrow this March 5-7, 2024 at BatStateU The NEU Alangilan.\n\nTechnofusion is the annual culminating activity of the College of Informatics and Computing Sciences that highlights students’ talents and skills through academic, nonacademic, cultural, and e-sports activities.\n\nWhere every dream finds its wings and every heart discovers its happily ever after; We will see you there, in the place where dreams come true. \n\n#UnleashThePower \n#TECHNOFUSION2024\n#EverUpward '
  }
];

const List<Map<String, String>> officers = [
  {
    'name': 'Yeleina Lagajeno',
    'position': 'President',
    'photo': 'assets/images/Off_President.png',
    'details':
        'Fourth Year | IT-4109 \nYeleina P. Lagajeno is the President of CICS Student Council.',
  },
  {
    'name': 'Kris Nathaniel Dimaapi ',
    'position': 'External Vice Presidentt',
    'photo': 'assets/images/Off_ExternalVicePresident.png',
    'details':
        'Fourth Year | IT-4104 \nKris Nathaniel Dimaapi is the External Vice President of CICS Student Council.',
  },
  {
    'name': 'Demmer Marvic Valeriano',
    'position': 'Internal Vice President',
    'photo': 'assets/images/Off_InternalVicePresident.png',
    'details':
        'Third Year |	IT-3103 \nDemmer Marvic Valeriano is the Internal Vice President of CICS Student Council.',
  },
  {
    'name': 'Mark Wilhem Trevor Marco',
    'position': 'Secretary',
    'photo': 'assets/images/Off_Secretary.png',
    'details':
        'Third Year | CS-3102 \nMark Wilhem Trevor Marco is the Secretary of CICS Student Council.',
  },
  {
    'name': 'Patricia Anne Mangubat',
    'position': 'Treasurer',
    'photo': 'assets/images/Off_Treasurer.png',
    'details':
        'Fourth Year	IT4104 \nPatricia Anne Mangubat is the Treasurer of CICS Student Council.',
  },
  {
    'name': 'Richard Crue Torre',
    'position': 'Assistant Treasurer',
    'photo': 'assets/images/Off_AsstTreasurer.png',
    'details':
        'Second Year	CS2102 \nRichard Crue Torre is the Assistant Treasurer of CICS Student Council.',
  },
  {
    'name': 'Nathalie Ellaina Anicasn',
    'position': 'Auditor',
    'photo': 'assets/images/Off_Auditor.png',
    'details':
        'Fourth Year	| CS-4105 \nNathalie Ellaina Anicas is the Auditor of CICS Student Council.',
  },
  {
    'name': 'Art Cedrick Platon',
    'position': 'Public Relations Officer',
    'photo': 'assets/images/Off_PRO.png',
    'details':
        'Fourth Year	| IT-4103 Art Cedrick Platon is the Public Relations Officer of CICS Student Council.',
  },
  {
    'name': 'Rhea Anne Gonzales',
    'position': 'Public Relations Officer',
    'photo': 'assets/images/Off_PRO2.png',
    'details':
        'Fourth Year	IT-4102 \nRhea Anne Gonzales is the Public Relations Officer of CICS Student Council.',
  },
  {
    'name': 'Jansen Cruzat',
    'position': 'Business Manager',
    'photo': 'assets/images/Off_BusinessManager.png',
    'details':
        'Third Year	| IT-3102 \nIvy Jackson is the Business Manager of CICS Student Council.',
  },
  {
    'name': 'Iemerie Jom Mangui',
    'position': 'Business Manager',
    'photo': 'assets/images/Off_BusinessManager2.png',
    'details':
        'Third Year | CS-3101 \nIemerie Jom Mangui is the Business Manager of CICS Student Council.',
  },
];

const String description =
    '     The CICS Organization is a dynamic and inclusive community within the College of Informatics and Computing Sciences, dedicated to supporting the academic and personal growth of its students. It serves as a platform for students to engage in various initiatives, enhancing their educational experience and preparing them for future careers in the IT and computing fields. The organization regularly hosts workshops, seminars, and networking events, providing members with valuable opportunities to learn from industry professionals and collaborate on projects. Through its efforts, the CICS Organization aims to create a vibrant and supportive environment where students can develop their skills, build meaningful connections, and contribute to the college community. \n\nThe objectives of the organization: \n-Develop the spirit of leadership among the students enrolled in the College of Informatics and Computing Sciences;\n-Help in uplifting the educational standard of the college through latest Computer and Information Technology;\n-Provide equality among its members;\n-Promote general welfare of the students enrolled in the college;\n-Organize activities for and on behalf of its members;\n-Promote contact and cooperation between the members of the organization; and\n-Provide equal opportunity for the expression of students’ opinion within the college on all matters of interest to students.';

const List<Map<String, String>> faqs = [
  {
    'question': '   What programs does CICS offer?',
    'answer':
        'CICS offers two programs including Computer Science, Information Technology.'
  },
  {
    'question': '   How can I apply for CICS programs?',
    'answer':
        'You can apply for CICS programs through the university’s official admissions portal.'
  },
  {
    'question': '   How can we settle our liability in CICS SC?',
    'answer':
        'You can pay your liability in the office of CICS SC, ground floor at the left side.'
  },
  {
    'question':
        '   If we are an irregular students, how can we ask our concerns?',
    'answer':
        'The CICS SC have a fb page, you can message us there so that we can address your concerns.'
  },
  {
    'question':
        '   If we are an irregular students, how can we ask our concerns?',
    'answer':
        'The CICS SC have a fb page, you can message us there so that we can address your concerns.'
  },
  {
    'question': '   How can we avail the organizations shirt?',
    'answer':
        'By  contacting the  representative of each year or you can  go to the  office  located to ground floor left side..'
  },
  {
    'question':
        '    What will happen if the liability is not settled before enrollment?',
    'answer':
        'The liability is tagged to the student portal, which prevents the student from enrolling in courses for the next semester.'
  },
  {
    'question':
        '   Does the program offer free school supplies for the students?',
    'answer': 'Yes, like  free printing, bond paper,  pen, pencil and etc.'
  },
];
