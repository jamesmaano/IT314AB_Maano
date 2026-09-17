import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SocialScreen(),
    );
  }
}

class Friend {
  String name;
  String status;
  String friendStatus;
  bool isUnread;
  bool isHeader;
  String headerTitle;
  String headerCount;

  Friend({
    String? name,
    String? status,
    String? friendStatus,
    bool? isUnread,
    bool? isHeader,
    String? headerTitle,
    String? headerCount,
  })  : name = name ?? 'Unknown User',
        status = status ?? 'Offline',
        friendStatus = friendStatus ?? 'Away',
        isUnread = isUnread ?? false,
        isHeader = isHeader ?? false,
        headerTitle = headerTitle ?? '',
        headerCount = headerCount ?? '0';
}

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() {
    return _SocialScreenState();
  }
}

class _SocialScreenState extends State<SocialScreen> {
  List<Friend> myFriends = [];

  @override
  void initState() {
    super.initState();
    setupFriendList();
  }

  void setupFriendList() {
    Friend header1 = Friend(
      isHeader: true,
      headerTitle: 'VALORANT',
      headerCount: '3',
    );

    Friend friend1 = Friend(
      name: 'MissYouLikeKrazy',
      status: 'Online - VALORANT',
      friendStatus: 'Online',
      isUnread: true,
    );

    Friend friend2 = Friend(
      name: 'bread',
      status: 'Playing - VALORANT',
      friendStatus: 'Playing',
    );

    Friend friend3 = Friend(
      name: 'The14th',
      status: 'Playing - VALORANT',
      friendStatus: 'Playing',
    );

    Friend header2 = Friend(
      isHeader: true,
      headerTitle: 'Online',
      headerCount: '4',
    );

    Friend friend4 = Friend(
      name: 'Carlvendish',
      status: 'Away - Riot Mobile',
      friendStatus: 'Away',
    );

    Friend friend5 = Friend(
      name: 'D1yah',
      status: 'Away - Riot Mobile',
      friendStatus: 'Away',
      isUnread: true,
    );

    Friend friend6 = Friend(
      name: 'noobsaur',
      status: 'Away - Riot Mobile',
      friendStatus: 'Away',
    );

    Friend friend7 = Friend(
      name: 'PlayerOne',
      status: 'Away - Riot Mobile',
      friendStatus: 'Away',
    );

    myFriends.add(header1);
    myFriends.add(friend1);
    myFriends.add(friend2);
    myFriends.add(friend3);
    myFriends.add(header2);
    myFriends.add(friend4);
    myFriends.add(friend5);
    myFriends.add(friend6);
    myFriends.add(friend7);
  }

  void goToChatRoom(Friend currentFriend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChatRoomScreen(friend: currentFriend);
        },
      ),
    );
  }

  void toggleUnread(Friend currentFriend) {
    if (currentFriend.isUnread == true) {
      currentFriend.isUnread = false;
    } else {
      currentFriend.isUnread = true;
    }
    setState(() {});
  }

  void removeFriendAt(int index) {
    setState(() {
      myFriends.removeAt(index);
    });
  }
  Color getDotColor(String friendStatus) {
    if (friendStatus == 'Online') {
      return Colors.green;
    } else if (friendStatus == 'Playing') {
      return Colors.cyan;
    } else if (friendStatus == 'Away') {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }

  IconData getDotIcon(String friendStatus) {
    if (friendStatus == 'Playing') {
      return Icons.play_arrow;
    } else {
      return Icons.circle;
    }
  }

  IconData getPlatformIcon(String status) {
    if (status.contains('VALORANT')) {
      return Icons.monitor;
    } else {
      return Icons.smartphone;
    }
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        'Social',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildTabs() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Friends',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Container(
                height: 2,
                width: 50,
                color: Colors.red,
              ),
            ],
          ),
          SizedBox(width: 24),
          Text(
            'Messages',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 24),
          Text(
            'Requests',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderRow(Friend currentFriend) {
    Widget headerIconSection = SizedBox(width: 0);

    if (currentFriend.headerTitle == 'VALORANT') {
      headerIconSection = Row(
        children: [
          Icon(
            Icons.play_circle_fill,
            color: Colors.red,
            size: 22,
          ),
          SizedBox(width: 8),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          headerIconSection,
          Text(
            currentFriend.headerTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 8),
          Text(
            currentFriend.headerCount,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFriendRow(Friend currentFriend, int index) {
    Color dotColor = getDotColor(currentFriend.friendStatus);
    IconData dotIcon = getDotIcon(currentFriend.friendStatus);
    IconData platformIcon = getPlatformIcon(currentFriend.status);

    Widget unreadDot = SizedBox(width: 0);

    if (currentFriend.isUnread == true) {
      unreadDot = SizedBox(
        width: 8,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Dismissible(
      key: ValueKey(currentFriend.name),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        removeFriendAt(index);
      },
      child: GestureDetector(
        onTap: () {
          goToChatRoom(currentFriend);
        },
        onLongPress: () {
          toggleUnread(currentFriend);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white12,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        dotIcon,
                        size: 8,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          currentFriend.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        unreadDot,
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          platformIcon,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 6),
                        Text(
                          currentFriend.status,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFriendListItem(int index) {
    Friend currentFriend = myFriends[index];

    if (currentFriend.isHeader == true) {
      return buildHeaderRow(currentFriend);
    } else {
      return buildFriendRow(currentFriend, index);
    }
  }

  Widget buildFriendList() {
    return Expanded(
      child: ListView.builder(
        itemCount: myFriends.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return buildFriendListItem(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(),
            SizedBox(height: 20),
            buildTabs(),
            SizedBox(height: 20),
            buildSearchBar(),
            SizedBox(height: 10),
            buildFriendList(),
          ],
        ),
      ),
    );
  }
}


class ChatRoomScreen extends StatelessWidget {
  final Friend friend;

  const ChatRoomScreen({super.key, required this.friend});

  Color getStatusColor(String friendStatus) {
    if (friendStatus == 'Online') {
      return Colors.green;
    } else if (friendStatus == 'Playing') {
      return Colors.cyan;
    } else if (friendStatus == 'Away') {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }

  IconData getStatusIcon(String friendStatus) {
    if (friendStatus == 'Playing') {
      return Icons.play_circle_fill;
    } else {
      return Icons.circle;
    }
  }

  IconData getPlatformIcon(String status) {
    if (status.contains('VALORANT')) {
      return Icons.monitor;
    } else {
      return Icons.smartphone;
    }
  }

  Widget buildAppBarTitle() {
    Color statusColor = getStatusColor(friend.friendStatus);
    IconData statusIcon = getStatusIcon(friend.friendStatus);
    IconData platformIcon = getPlatformIcon(friend.status);

    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white12,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  size: 10,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              friend.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  platformIcon,
                  size: 12,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  friend.status,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMessageInputBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Send a message',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: buildAppBarTitle(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox.expand(),
          ),
          buildMessageInputBar(),
        ],
      ),
    );
  }
}