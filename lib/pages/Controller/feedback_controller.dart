import 'package:cfp_app/providers/feedback_repository.dart';
import 'package:cfp_app/models/feedback_model.dart';

class FeedbackController {
  final FeedbackProvider _feedbackProvider;
  FeedbackController(this._feedbackProvider);

  Future<FeedbackCliente> getDadosFeedback(String clienteCpf) async {
    return await _feedbackProvider.getDadosFeedback();
  }

  Future<void> deletarFeedback(context, FeedbackCliente feedbackCliente) async {
    return await _feedbackProvider.deletarFeedback(feedbackCliente);
  }

  Future<List<FeedbackCliente>> fetchFeedbacks() async {
    return await _feedbackProvider.fetchFeedbacks();
  }

  Future<void> cadastrarFeedback(FeedbackCliente feedbackCliente) async {
    return await _feedbackProvider.cadastrarFeedback(feedbackCliente);
  }

  Future<void> atualizarFeedback(FeedbackCliente feedbackCliente) async {
    return await _feedbackProvider.atualizarFeedback(feedbackCliente);
  }
}
