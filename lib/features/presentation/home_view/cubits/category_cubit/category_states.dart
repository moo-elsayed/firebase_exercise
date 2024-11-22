abstract class CategoryStates {}

class CategoryInitial extends CategoryStates {}

class AddCategoryInitial extends CategoryStates {}

class AddCategorySuccess extends CategoryStates {}

class AddCategoryLoading extends CategoryStates {}

class AddCategoryFailure extends CategoryStates {}

class CategoryLoading extends CategoryStates {}

class CategorySuccess extends CategoryStates {
  List categoryList;

  CategorySuccess({required this.categoryList});
}

class CategoryFailure extends CategoryStates {}

class UpdateCategoryLoading extends CategoryStates {}

class UpdateCategorySuccess extends CategoryStates {}

class UpdateCategoryFailure extends CategoryStates {}
