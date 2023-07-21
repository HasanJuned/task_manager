class Urls {
  static String baseUrl = 'https://task.teamrabbil.com/api/v1';

  static String changeTaskUrl(String taskId, String status) =>
      '$baseUrl/updateTaskStatus/$taskId/$status';

  static String deleteTaskUrl(String id) =>
      '$baseUrl/deleteTask/$id';

  static String recoveryEmailUrl(String email) =>
      '$baseUrl/RecoverVerifyEmail/$email';

  static String recoveryOtpUrl(String email, String otp) =>
      '$baseUrl/RecoverVerifyOTP/$email/$otp';

  static String resetPasswordUrl = '$baseUrl/RecoverResetPass';

}
