class Access {
  bool accessFull;
  bool accessRead;
  bool accessCreate;
  bool accessUpdate;
  bool accessDelete;
  bool accessSettingsRead;
  bool accessSettingsUpdate;

  Access(
      {this.accessFull,
      this.accessRead,
      this.accessCreate,
      this.accessUpdate,
      this.accessDelete,
      this.accessSettingsRead,
      this.accessSettingsUpdate});

  Access.fromJson(Map<String, dynamic> json) {
    accessFull = json['access_Full'];
    accessRead = json['access_Read'];
    accessCreate = json['access_Create'];
    accessUpdate = json['access_Update'];
    accessDelete = json['access_Delete'];
    accessSettingsRead = json['access_Settings_Read'];
    accessSettingsUpdate = json['access_Settings_Update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_Full'] = this.accessFull;
    data['access_Read'] = this.accessRead;
    data['access_Create'] = this.accessCreate;
    data['access_Update'] = this.accessUpdate;
    data['access_Delete'] = this.accessDelete;
    data['access_Settings_Read'] = this.accessSettingsRead;
    data['access_Settings_Update'] = this.accessSettingsUpdate;
    return data;
  }
}
