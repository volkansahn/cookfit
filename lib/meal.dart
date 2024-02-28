class Meal {
  int? healthScore;
  int? id;
  String? title;
  int? readyInMinutes;
  int? servings;
  String? sourceUrl;
  String? image;
  Nutrition? nutrition;
  String? summary;
  List<String>? cuisines;
  List<String>? dishTypes;
  List<String>? diets;
  List<String>? occasions;
  List<AnalyzedInstructions>? analyzedInstructions;

  Meal(
      {this.healthScore,
      this.id,
      this.title,
      this.readyInMinutes,
      this.servings,
      this.sourceUrl,
      this.image,
      this.nutrition,
      this.summary,
      this.cuisines,
      this.dishTypes,
      this.diets,
      this.occasions,
      this.analyzedInstructions});
  // Constructor to create a Meal object from a map
  Meal.fromMap(Map<String, dynamic> map) {
    healthScore = map['healthScore'];
    id = map['id'];
    title = map['title'];
    readyInMinutes = map['readyInMinutes'];
    servings = map['servings'];
    sourceUrl = map['sourceUrl'];
    image = map['image'];
    nutrition =
        map['nutrition'] != null ? Nutrition.fromMap(map['nutrition']) : null;
    summary = map['summary'];
    cuisines = List<String>.from(map['cuisines'] ?? []);
    dishTypes = List<String>.from(map['dishTypes'] ?? []);
    diets = List<String>.from(map['diets'] ?? []);
    occasions = List<String>.from(map['occasions'] ?? []);
    if (map['analyzedInstructions'] != null) {
      analyzedInstructions = List<AnalyzedInstructions>.from(
        (map['analyzedInstructions'] as List<dynamic>)
            .map((item) => AnalyzedInstructions.fromMap(item)),
      );
    }
  }
  Meal.fromJson(Map<String, dynamic> json) {
    healthScore = json['healthScore'];
    id = json['id'];
    title = json['title'];
    readyInMinutes = json['readyInMinutes'];
    servings = json['servings'];
    sourceUrl = json['sourceUrl'];
    image = json['image'];
    nutrition = json['nutrition'] != null
        ? Nutrition.fromJson(json['nutrition'])
        : null;
    summary = json['summary'];
    cuisines = json['cuisines'].cast<String>();
    dishTypes = json['dishTypes'].cast<String>();
    diets = json['diets'].cast<String>();
    occasions = json['occasions'].cast<String>();
    if (json['analyzedInstructions'] != null) {
      analyzedInstructions = <AnalyzedInstructions>[];
      json['analyzedInstructions'].forEach((v) {
        analyzedInstructions!.add(AnalyzedInstructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['healthScore'] = healthScore;
    data['id'] = id;
    data['title'] = title;
    data['readyInMinutes'] = readyInMinutes;
    data['servings'] = servings;
    data['sourceUrl'] = sourceUrl;
    data['image'] = image;
    data['summary'] = summary;
    data['cuisines'] = cuisines;
    data['dishTypes'] = dishTypes;
    data['diets'] = diets;
    data['occasions'] = occasions;
    if (nutrition != null) {
      data['nutrition'] = nutrition!.toJson();
    }
    if (analyzedInstructions != null) {
      data['analyzedInstructions'] =
          analyzedInstructions!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Nutrition {
  List<Nutrients>? nutrients;
  List<Ingredients>? ingredients;

  Nutrition({this.nutrients, this.ingredients});

  factory Nutrition.fromMap(Map<String, dynamic> map) {
    return Nutrition(
      nutrients: map['nutrients'] != null
          ? List<Nutrients>.from((map['nutrients'] as List<dynamic>)
              .map((item) => Nutrients.fromMap(item)))
          : null,
      ingredients: map['ingredients'] != null
          ? List<Ingredients>.from((map['ingredients'] as List<dynamic>)
              .map((item) => Ingredients.fromMap(item)))
          : null,
    );
  }

  Nutrition.fromJson(Map<String, dynamic> json) {
    if (json['nutrients'] != null) {
      nutrients = <Nutrients>[];
      json['nutrients'].forEach((v) {
        nutrients!.add(Nutrients.fromJson(v));
      });
    }
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(Ingredients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nutrients != null) {
      data['nutrients'] = nutrients!.map((v) => v.toJson()).toList();
    }
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nutrients {
  String? name;
  double? amount;
  String? unit;
  double? percentOfDailyNeeds;

  Nutrients({this.name, this.amount, this.unit, this.percentOfDailyNeeds});

  factory Nutrients.fromMap(Map<String, dynamic> map) {
    return Nutrients(
      name: map['name'],
      amount: map['amount'],
      unit: map['unit'],
      percentOfDailyNeeds: map['percentOfDailyNeeds'],
    );
  }

  Nutrients.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    unit = json['unit'];
    percentOfDailyNeeds = json['percentOfDailyNeeds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    data['unit'] = unit;
    data['percentOfDailyNeeds'] = percentOfDailyNeeds;
    return data;
  }
}

class Ingredients {
  int? id;
  String? name;
  double? amount;
  String? unit;

  Ingredients({this.id, this.name, this.amount, this.unit});

  factory Ingredients.fromMap(Map<String, dynamic> map) {
    return Ingredients(
      id: map['id'],
      name: map['name'],
      amount: map['amount']?.toDouble(),
      unit: map['unit'],
    );
  }

  Ingredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount']?.toDouble();
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['unit'] = unit;
    return data;
  }
}

class AnalyzedInstructions {
  String? name;
  List<Steps>? steps;

  AnalyzedInstructions({this.name, this.steps});

  factory AnalyzedInstructions.fromMap(Map<String, dynamic> map) {
    return AnalyzedInstructions(
      name: map['name'],
      steps:
          List<Steps>.from((map['steps'] ?? []).map((x) => Steps.fromMap(x))),
    );
  }

  AnalyzedInstructions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(Steps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Steps {
  int? number;
  String? step;
  List<InstructionIngredients>? ingredients;
  List<Equipment>? equipment;
  Length? length;

  Steps(
      {this.number, this.step, this.ingredients, this.equipment, this.length});

  factory Steps.fromMap(Map<String, dynamic> map) {
    return Steps(
      number: map['number'],
      step: map['step'],
      ingredients: List<InstructionIngredients>.from((map['ingredients'] ?? [])
          .map((x) => InstructionIngredients.fromMap(x))),
      equipment: List<Equipment>.from(
          (map['equipment'] ?? []).map((x) => Equipment.fromMap(x))),
      length: map['length'] != null ? Length.fromMap(map['length']) : null,
    );
  }

  Steps.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    step = json['step'];
    if (json['ingredients'] != null) {
      ingredients = <InstructionIngredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(InstructionIngredients.fromJson(v));
      });
    }
    if (json['equipment'] != null) {
      equipment = <Equipment>[];
      json['equipment'].forEach((v) {
        equipment!.add(Equipment.fromJson(v));
      });
    }
    length = json['length'] != null ? Length.fromJson(json['length']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['step'] = step;
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    if (equipment != null) {
      data['equipment'] = equipment!.map((v) => v.toJson()).toList();
    }
    if (length != null) {
      data['length'] = length!.toJson();
    }
    return data;
  }
}

class InstructionIngredients {
  int? id;
  String? name;
  String? localizedName;
  String? image;

  InstructionIngredients({this.id, this.name, this.localizedName, this.image});

  factory InstructionIngredients.fromMap(Map<String, dynamic> map) {
    return InstructionIngredients(
      id: map['id'],
      name: map['name'],
      localizedName: map['localizedName'],
      image: map['image'],
    );
  }

  InstructionIngredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    localizedName = json['localizedName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['localizedName'] = localizedName;
    data['image'] = image;
    return data;
  }
}

class Equipment {
  int? id;
  String? name;
  String? localizedName;
  String? image;

  Equipment({this.id, this.name, this.localizedName, this.image});

  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'],
      name: map['name'],
      localizedName: map['localizedName'],
      image: map['image'],
    );
  }

  Equipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    localizedName = json['localizedName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['localizedName'] = localizedName;
    data['image'] = image;
    return data;
  }
}

class Length {
  int? number;
  String? unit;

  Length({this.number, this.unit});

  factory Length.fromMap(Map<String, dynamic> map) {
    return Length(
      number: map['number'],
      unit: map['unit'],
    );
  }

  Length.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['unit'] = unit;
    return data;
  }
}
