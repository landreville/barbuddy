export function sortIngredients(a, b) {
  if (a.unit === 'ounce' && b.unit !== 'ounce') {
    return -1;
  } else if (b.unit === 'ounce' && a.unit !== 'ounce') {
    return 1;
  }

  if (a.unit !== b.unit) {
    if (a.unit === null) {
      return 1;
    } else if (b.unit === null) {
      return -1;
    }
    let x = a.unit.toLowerCase();
    let y = b.unit.toLowerCase();
    if (x < y) {
      return -1;
    } else if (x > y) {
      return 1;
    }
  }

  if (b.amount === a.amount) {
    let x = a.ingredient_name.toLowerCase();
    let y = b.ingredient_name.toLowerCase();
    if (x < y) {
      return -1;
    } else if (x > y) {
      return 1;
    }
  }

  return b.amount - a.amount;
};
