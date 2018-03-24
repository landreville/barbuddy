function (doc) {
  if (doc.type == 'recipe' && doc.live) {
    if (doc.catalog) {
      emit(doc.catalog, null);
    }
  }
};

// Recipes by ID
function (doc) {
  if (doc.type === 'recipe' && doc.live) {
    emit(doc._id, doc);
  }
};

// Recipes by catalog, name
// function (doc) {
//   if (doc.type === 'recipe' && doc.live) {
//     var emitDoc = {
//       'name': doc.name,
//       'catalog': doc.catalog,
//       'description': doc.description,
//       'vessel': doc.vessel
//     };
//     emit([doc.catalog, doc.name], emitDoc);
//   }
// };

// Recipes by name
function (doc) {
  if (doc.type === 'recipe' && doc.live) {
    var emitDoc = {
      'name': doc.name,
      'catalog': doc.catalog,
      'description': doc.description,
      'vessel': doc.vessel
    };
    emit(doc.name, emitDoc);
  }
};

// Recipes by catalog
function (doc) {
  if (doc.type === 'recipe' && doc.live) {
    var emitDoc = {
      'name': doc.name,
      'catalog': doc.catalog,
      'description': doc.description,
      'vessel': doc.vessel
    };
    emit(doc.catalog, emitDoc);
  }
};

// Recipes by ingredient
function (doc) {
  if (doc.type === 'recipe' && doc.live && doc.ingredients) {
    var ingredients = doc.ingredients;
    var emitDoc = {
      'name': doc.name,
      'catalog': doc.catalog,
      'description': doc.description,
      'vessel': doc.vessel
    };

    for (var i = 0; i < ingredients.length; i++) {
      var ingredient = ingredients[i];
      if (ingredient.name) {
        emit(ingredient.name, emitDoc);
      }
      if (ingredient.category){
        emit(ingredient.category, emitDoc);
      }

      if (ingredient.alternatives) {
        var alts = ingredient.alternatives;
        for (var j = 0; j < alts.length; j++) {
          var alt = alts[j];
          if (alt.name) {
            emit(alt.name, emitDoc);
          }
          if (alt.category) {
            emit(alt.category, emitDoc);
          }
        }
      }
    }
  }
};

// Ingredients
function (doc) {
  if (doc.type === 'recipe' && doc.live) {
    var ingredients = doc.ingredients;

    for (var i = 0; i < ingredients.length; i++) {
      var ingredient = ingredients[i];

      emit(ingredient.name, {"name": ingredient.name, "category": ingredient.category});
      if (ingredient.category){
        emit(ingredient.category, {"name": ingredient.category, "category": ingredient.category});
      }

      if (ingredient.alternatives) {
        var alts = ingredient.alternatives;
        for (var j = 0; j < alts.length; j++) {
          var alt = alts[j];
          emit(alt.name, {"name": alt.name, "category": alt.category});
          if (alt.category){
            emit(alt.category, {"name": alt.category, "category": alt.category});
          }
        }
      }
    }
  }
};

// validate_doc_update
function (newDoc, oldDoc, userCtx) {
  if (userCtx.roles.indexOf('_admin') === -1) {
    throw({ forbidden: 'Permission denied.' });
  }

  var validTypes = ['recipe', 'ingredient', 'favourite', 'user'];
  if (validTypes.indexOf(newDoc.type) === -1) {
    throw({ forbidden: 'Unknown document type.' });
  }

  if (oldDoc && oldDoc.type !== newDoc.type) {
    throw({ forbidden: 'Cannot change type of document.' });
  }

  function require(field, message, doctype) {
    doctype = doctype || 'Document';
    message = message || doctype + ' must have a ' + field;
    if (!newDoc[field]) {
      throw({ forbidden: message });
    }
  }

  if (newDoc.type === 'recipe') {
    require('name');
    require('ingredients');
  } else if (newDoc.type === 'favourite') {
    require('recipeId');
    require('userId');
  } else if (newDoc.type === 'ingredient') {
    require('name');
  }
};
