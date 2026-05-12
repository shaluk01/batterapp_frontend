import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // =========================
  // SEND OTP
  // =========================

  Future<void> sendOTP({

    required String phone,

    required Function(String verificationId)
        codeSent,

    required Function(String error)
        onError,

  }) async {

    await _auth.verifyPhoneNumber(

      phoneNumber: "+91$phone",

      verificationCompleted:
          (PhoneAuthCredential credential) async {

        await _auth.signInWithCredential(
          credential,
        );
      },

      verificationFailed:
          (FirebaseAuthException e) {

        onError(e.message ?? "OTP Failed");
      },

      codeSent:
          (String verificationId,
          int? resendToken) {

        codeSent(verificationId);
      },

      codeAutoRetrievalTimeout:
          (String verificationId) {},
    );
  }

  // =========================
  // VERIFY OTP
  // =========================

  Future<UserCredential> verifyOTP({

    required String verificationId,

    required String otp,

  }) async {

    PhoneAuthCredential credential =

        PhoneAuthProvider.credential(

      verificationId: verificationId,

      smsCode: otp,
    );

    return await _auth.signInWithCredential(
      credential,
    );
  }
}