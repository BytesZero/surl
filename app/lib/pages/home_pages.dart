import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surlapp/http/app_http.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String surl = "点击 + 号生成短链";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Surl App"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => copyUrl(),
          child: Text(
            surl,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Surl',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 弹出底部输入框
  Future<void> _showDialog() async {
    final TextEditingController _controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("请输入链接"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "请输入链接",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                getSurl(_controller.text);
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  /// 获取短链
  Future<void> getSurl(String url) async {
    String surl = await genSurl(url);
    setState(() {
      this.surl = surl;
    });
    print("✅ 生成完成：$surl");
  }

  /// 复制链接
  Future<void> copyUrl() async {
    Clipboard.setData(ClipboardData(text: surl));
    print("✅ 复制成功");
  }
}
