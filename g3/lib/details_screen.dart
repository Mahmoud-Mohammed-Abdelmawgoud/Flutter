import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g3/cubits/popular_info_cubit/popular_info_cubit.dart';
import 'image_screen.dart';

class DetailsScreen extends StatefulWidget {
  final int id;

  DetailsScreen(this.id);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the API call using the PopularInfoCubit
    PopularInfoCubit.get(context).getPopularInfo(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: BlocBuilder<PopularInfoCubit, PopularInfoState>(
        builder: (context, state) {
          if (state is PopularInfoLoading) {
            // Show loading indicator when loading state is emitted
            return Center(child: CircularProgressIndicator());
          } else if (state is PopularInfoDone) {
            // Show details when the loading is done
            final model = state.popularInfoModel; // Assume state has the model
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Biography: ${model.biography ?? 'No biography available'}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Display images or other details using model data
              ],
            );
          } else if (state is PopularInfoError) {
            // Show error message when an error occurs
            return Center(child: Text('Failed to load data.'));
          } else {
            // Default empty state
            return Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
