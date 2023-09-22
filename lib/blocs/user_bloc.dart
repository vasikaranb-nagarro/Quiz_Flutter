import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/blocs/services.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  final String? error;

  const UserInitial({this.error});

  @override
  List<Object?> get props => [error];
}

class UserLoginFailure extends UserState {}

class UserAuthenticated extends UserState {
  final User user;
  final String email;
  String? profilePictureUrl;

  UserAuthenticated(this.user, this.email, this.profilePictureUrl);

  @override
  List<Object?> get props => [user, email];
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserBloc() : super(const UserInitial()) {
    on<UserLogin>((event, emit) => _mapUserLoginToState(event, emit));
    on<UserSignup>((event, emit) => _mapUserSignupToState(event, emit));
    on<UserLogout>((event, emit) => _mapUserLogoutToState(event, emit));
  }

  void logout() {
    _firebaseAuth.signOut();
    emit(const UserInitial());
  }

  void _mapUserLoginToState(UserLogin event, Emitter<UserState> emit) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final profilePictureUrl =
          await fetchProfilePictureUrlFromFirebase(event.email);
      emit(UserAuthenticated(userCredential.user!, userCredential.user!.email!,
          profilePictureUrl));
    } catch (e) {
      emit(UserLoginFailure());
      emit(UserInitial(error: e.toString()));
    }
  }

  void _mapUserLogoutToState(UserLogout event, Emitter<UserState> emit) async {
    try {
      logout();
    } catch (e) {
      logout();
    }
  }

  void _mapUserSignupToState(UserSignup event, Emitter<UserState> emit) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(UserAuthenticated(
          userCredential.user!, userCredential.user!.email!, ""));
    } catch (e) {
      emit(UserLoginFailure());
      emit(UserInitial(error: e.toString()));
    }
  }
}

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserLogin extends UserEvent {
  final String email;
  final String password;

  const UserLogin(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class UserSignup extends UserEvent {
  final String email;
  final String password;

  const UserSignup(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class UserLogout extends UserEvent {}
