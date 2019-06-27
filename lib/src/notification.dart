class Notification {
  int id;
  String targetID;
  String notifyGroupId;

  /// According to LumiNUS Developer's portal, possible notification types
  /// are: 1 = Module, 2 = Folder, 6 = Forum, 7 = Multimedia,
  /// 8 = WebLecture, 10 = WebEx, 11 = LibraryFolder, 13 = Announcement,
  /// 14 = Consultation, 15 = Evaluation, 16 = SCORM, 17 = BankFolder, 19 = Survey,
  /// 20 = Assessment, 22 = LibraryMedia, 24 = File, 25 = Weblink, 27 = Comment,
  /// 28 = TextAndReadings, 29 = CourseDescription, 31 = GradebookItem,
  /// 32 = GradebookItemScore, 33 = Attendance, 34 = AttendanceMark, 35 = ForumHeadings,
  /// 36 = ForumPost, 37 = SeatingPlan, 41 = ForumArchives, 42 = ForumPostArchived,
  /// 44 = MediaPlaylist, 45 = MediaItemSubtitlesCC, 47 = LessonFlow, 48 = LessonActivity,
  /// 51 = WebLectureItem, 54 = ConsultationSlot, 55 = CourseManager, 56 = Question,
  /// 57 = QuestionResponse, 58 = SurveySection, 59 = SurveySession, 60 = Rating,
  /// 62 = PackageItem, 63 = AssessmentSection, 64 = AssessmentSession, 65 = Heading,
  /// 66 = Package, 67 = SCO, 68 = CMIData, 69 = UserNavi, 70 = AttendanceItem,
  /// 71 = AttendanceUser, 72 = GradebookGradingSchema, 73 = Notification, 74 = Task,
  /// 75 = FeedbackSender, 76 = ExternalLink, 77 = Course, 78 = CourseRegistration,
  /// 79 = Note, 100 = LTI, 200 = TeampUp, 1000 = TaskClassGroupSignUp,
  /// 1001 = EventLecture, 1002 = EventTutorial, 1003 = EventLab, 1004 = OtherEvent"
  String type;
  String recordDate;
  String notifyMessage;
  int notifyStatus;

  Notification(
      {this.id,
      this.targetID,
      this.notifyGroupId,
      this.type,
      this.recordDate,
      this.notifyMessage,
      this.notifyStatus});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    targetID = json['targetID'];
    notifyGroupId = json['notifyGroupId'];
    type = json['type'];
    recordDate = json['recordDate'];
    notifyMessage = json['notifyMessage'];
    notifyStatus = json['notifyStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['targetID'] = this.targetID;
    data['notifyGroupId'] = this.notifyGroupId;
    data['type'] = this.type;
    data['recordDate'] = this.recordDate;
    data['notifyMessage'] = this.notifyMessage;
    data['notifyStatus'] = this.notifyStatus;
    return data;
  }

  @override
  int get hashCode => id;

  @override
  String toString() => '[Notifictaion of type $type] $notifyMessage';
}
