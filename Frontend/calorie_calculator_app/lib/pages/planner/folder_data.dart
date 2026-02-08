import 'package:flutter/material.dart';

class FolderNotifier extends ChangeNotifier
{
	String name = "";

	void updateControllers({String? folderName})
	{
		if(folderName != null) name = folderName;
	}
}