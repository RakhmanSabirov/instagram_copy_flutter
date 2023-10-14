import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  int commentLike = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(text: TextSpan(
                      children: [TextSpan(
                        text: widget.snap['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                        TextSpan(
                            text: ' ${widget.snap['text']}',
                        )
                      ]
                    )),
                    Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(DateFormat.yMMMd().format(
                          widget.snap['datePublished'].toDate()
                        ),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 12),) ,
                    )
                  ],
                ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                child: IconButton(
                  onPressed: (){
                    
                  },
                  icon : Icon(Icons.favorite,size: 16)),
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("2"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
