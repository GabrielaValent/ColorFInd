import 'package:flutter/material.dart';
import 'package:testedb2/home.dart';



class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children:<Widget>[
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        children: <Widget>[
                          Text(
                            "ColorFind é uma aplicação para detecção de cores\n",
                            textAlign: TextAlign.justify,

                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            enableFeedback: false,
                            onPressed: () {
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 50,
                            ),
                          ),
                          Text(
                            "\n"
                                "Ao selecionar uma imagem, certifique-se de que o objeto do qual se deseja descobrir a cor esteja em foco\n",
                            textAlign: TextAlign.justify,

                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            enableFeedback: false,
                            onPressed: () {
                            },
                            icon: const Icon(
                              Icons.color_lens,
                              color: Colors.black,
                              size: 50,
                            ),
                          ),
                          Text(
                            "\n"
                                "A aba de cores armazena as suas buscas recentes\n",
                            textAlign: TextAlign.justify,

                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ]
                    )
                )
              ]
          ),
        ),
      ),
    );
  }
}