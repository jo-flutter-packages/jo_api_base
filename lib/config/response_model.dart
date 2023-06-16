import 'package:flutter/material.dart';

class ResponseModel<T> {
  bool isSuccess;
  String statusCode;
  String message;
  dynamic data;

  ResponseModel({
    this.isSuccess = false,
    this.statusCode = "local-error",
    this.message = "",
    this.data,
  });

  ResponseModel fromJson<T>(dynamic jsn) {
    statusCode = jsn["statusCode"].toString();
    data = jsn["data"];
    isSuccess = jsn["isSuccess"];
    message = jsn["message"].toString();

    return this;
  }

  String getMessage() {
    if (message.length > 100) {
      return message.substring(0, 100);
    }
    return message;
  }

  showMessage(BuildContext context) {
    final snackBar = SnackBar(
      content: SizedBox(
        height: 70.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSuccess ? "عملیات موفق" : "عملیات ناموفق",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: isSuccess ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            Text(
              getMessage(),
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showDialog(BuildContext context, Function(bool) onConfirmation) {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 3.0,
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontFamily: "iransans",
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      onConfirmation.call(true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Text(
                        "بله",
                        style: TextStyle(
                          fontFamily: "iransans",
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onConfirmation.call(false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).errorColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Text(
                        "خیر",
                        style: TextStyle(
                          fontFamily: "iransans",
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
