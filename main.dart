import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InitializationScreen(),
    );
  }
}

class InitializationScreen extends StatefulWidget {
  @override
  _InitializationScreenState createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  String? selectedTime; // 클래스 멤버 변수로 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('여러분의 정보가 궁금해요!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 이름 입력 필드
            Container(
              width: double.infinity,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: '이름을 입력하세요'),
              ),
            ),
            // 나이 입력 필드
            Container(
              width: double.infinity,
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: '나이를 입력하세요'),
                keyboardType: TextInputType.number,
              ),
            ),
            // 성별 입력 필드
            Container(
              width: double.infinity,
              child: TextField(
                controller: sexController,
                decoration: InputDecoration(hintText: '성별을 입력하세요'),
                keyboardType: TextInputType.text,
              ),
            ),
            // 주로 대화하는 시간대 선택
            Container(
              width: double.infinity,
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedTime,
                items: List.generate(25, (index) {
                  return DropdownMenuItem(
                    value: index.toString(),
                    child: Text(index.toString() + '시'),
                  );
                }),
                hint: Text('주로 대화하는 시간대를 선택하세요'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue;
                  });
                },
              ),
            ),
            // 제출 버튼
            ElevatedButton(
              onPressed: () {
                // 사용자의 정보를 가져오는 부분
                String name = nameController.text;
                String age = ageController.text;
                String sex = sexController.text;
                // 정보를 다음 화면으로 전달하거나 데이터베이스에 저장하는 로직 추가

                //다음화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordingScreen()),
                ); //예 : saveUserInfo(name, age, time);
              },
              child: Text('제출'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('녹음 파일 전송')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 여기를 수정
          children: [
            buildButton(
                context,
                '대화 녹음 파일 전송',
                "대화 시 음성을 전송해주세요. 발표 연습이나, 전화음성 같이 혼자만의 목소리가 있는 파일이면 좋답니다!",
                '대화 녹음 파일 전송'),
            buildButton(
                context,
                '노래방 녹음 파일 전송',
                "노래방에서 녹음한 파일을 전송해주세요. 어떤 노래든 괜찮습니다. 노래 구성은 음의 높고 낮음이 다양할 수록 좋아요!",
                '노래방 녹음 파일 전송'),
            buildButton(
                context,
                'Vocal only 녹음 파일 전송',
                "혹시 마이크로 홈 레코딩을 하시나요? MR없이 노래하는 목소리만 녹음한 파일을 전송해주세요. 최상의 퀄리티가 나올거에요",
                'Vocal only 녹음 파일 전송'),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, String tooltip,
      String nextScreenTitle) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UploadScreen(title: nextScreenTitle)),
            );
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 30), // 글자 크기를 30으로 설정
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 180), // 버튼의 세로 크기를 180으로 설정
          ),
        ),
      ),
    );
  }

  // 파일 선택 창을 띄우는 함수
  void _pickFile(BuildContext context) {
    // 파일 선택 로직
  }
}

class UploadScreen extends StatefulWidget {
  final String title;

  UploadScreen({required this.title});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? selectedFile;
  bool isLoading = false;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  setState(() {
                    selectedFile = File(result.files.single.path!);
                  });
                }
              },
              child: Text('파일 선택'),
            ),
            selectedFile != null
                ? Text(
                    '선택된 파일: ${selectedFile!.path.split('/').last}, 크기: ${((selectedFile!.lengthSync() / (1024 * 1024)).toStringAsFixed(2))} MB')
                : Container(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (selectedFile != null) {
                  setState(() {
                    isLoading = true;
                  });
                  // 파일 업로드 로직을 여기에 작성.
                  // 예시로 2초 대기 후 100% 완료.
                  await Future.delayed(Duration(seconds: 2));
                  setState(() {
                    progress = 1.0;
                    isLoading = false;
                  });

                  // 업로드 완료 시
                  if (progress == 1.0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnalysisInProgressScreen(
                                username: '남영진', // 이 부분은 실제 사용자 이름으로 변경해야 함
                              )),
                    );
                  }
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('업로드'),
            ),
            if (isLoading) LinearProgressIndicator(value: progress),
            if (isLoading)
              Text('업로드 중입니다: ${(progress * 100).toInt()}%',
                  style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class AnalysisInProgressScreen extends StatelessWidget {
  final String username;

  AnalysisInProgressScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('분석 중...'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '$username 님의 목소리를 분석 중입니다.\n$username 님의 목소리의 분석이 완료되면, 알림을 보내드릴게요!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
