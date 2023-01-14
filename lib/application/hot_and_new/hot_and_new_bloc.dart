// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:netflix_clone_app/domain/hot_and_new_response/hot_and_new_services.dart';
import 'package:netflix_clone_app/domain/hot_and_new_response/model/hot_and_new_response.dart';
import 'package:netflix_clone_app/domain/core/failures/main_failures.dart';

part 'hot_and_new_event.dart';
part 'hot_and_new_state.dart';
part 'hot_and_new_bloc.freezed.dart';

@injectable
class HotAndNewBloc extends Bloc<HotAndNewEvent, HotAndNewState> {
  final HotAndNewServices _hotAndNewServices;
  HotAndNewBloc(this._hotAndNewServices) : super(HotAndNewState.initial()) {
    // get hot and new movie data
    on<LoadDataInComingSoon>((event, emit) async {
      // send loading to UI
      emit(
        const HotAndNewState(
          comingSoonList: [],
          everyOneIsWatchingList: [],
          isLoading: true,
          hasError: false,
        ),
      );

      // get data from remote

      // ignore: no_leading_underscores_for_local_identifiers
      final _result = await _hotAndNewServices.getHotAndNewMovieData();

      // data to state
      // ignore: no_leading_underscores_for_local_identifiers
      final _newState = _result.fold(
        (MainFailures failure) {
          return const HotAndNewState(
            comingSoonList: [],
            everyOneIsWatchingList: [],
            isLoading: false,
            hasError: true,
          );
        },
        (HotAndNewResponse response) {
          return HotAndNewState(
            comingSoonList: response.results,
            everyOneIsWatchingList: state.everyOneIsWatchingList,
            isLoading: false,
            hasError: false,
          );
        },
      );

      emit(_newState);
    });

    //get hot and new tv data
    on<LoadDataInEveryoneIsWatching>((event, emit) async {
      // send loading to UI
      emit(
        const HotAndNewState(
          comingSoonList: [],
          everyOneIsWatchingList: [],
          isLoading: true,
          hasError: false,
        ),
      );

      // get data from remote

      // ignore: no_leading_underscores_for_local_identifiers
      final _result = await _hotAndNewServices.getHotAndNewTvData();

      // data to state
      // ignore: no_leading_underscores_for_local_identifiers
      final _newState = _result.fold(
        (MainFailures failure) {
          return const HotAndNewState(
            comingSoonList: [],
            everyOneIsWatchingList: [],
            isLoading: false,
            hasError: true,
          );
        },
        (HotAndNewResponse response) {
          return HotAndNewState(
            comingSoonList: state.comingSoonList,
            everyOneIsWatchingList: response.results,
            isLoading: false,
            hasError: false,
          );
        },
      );

      emit(_newState);
    });
  }
}
