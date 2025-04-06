document.addEventListener('DOMContentLoaded', function() {
  const menuForm = document.getElementById('menuForm');
  const menuItemsContainer = document.getElementById('menuItems');

  // Load existing menu items
  function loadMenuItems() {
    db.collection('menu_items').get().then((querySnapshot) => {
      menuItemsContainer.innerHTML = '';
      querySnapshot.forEach((doc) => {
        const item = doc.data();
        const itemElement = document.createElement('div');
        itemElement.className = 'border rounded p-4';
        itemElement.innerHTML = `
          <img src="${item.imageUrl}" alt="${item.name}" class="w-full h-32 object-cover mb-2">
          <h3 class="font-bold">${item.name}</h3>
          <p>${item.category} - $${item.price.toFixed(2)}</p>
          <div class="mt-2 flex space-x-2">
            <button onclick="editItem('${doc.id}')" class="bg-yellow-500 text-white px-2 py-1 rounded text-sm">
              Edit
            </button>
            <button onclick="deleteItem('${doc.id}')" class="bg-red-500 text-white px-2 py-1 rounded text-sm">
              Delete
            </button>
          </div>
        `;
        menuItemsContainer.appendChild(itemElement);
      });
    });
  }

  // Add new menu item
  menuForm.addEventListener('submit', (e) => {
    e.preventDefault();
    
    const newItem = {
      name: document.getElementById('itemName').value,
      category: document.getElementById('itemCategory').value,
      price: parseFloat(document.getElementById('itemPrice').value),
      imageUrl: document.getElementById('itemImage').value,
      createdAt: firebase.firestore.FieldValue.serverTimestamp()
    };

    db.collection('menu_items').add(newItem)
      .then(() => {
        menuForm.reset();
        loadMenuItems();
      })
      .catch((error) => {
        console.error("Error adding document: ", error);
      });
  });

  // Edit menu item
  window.editItem = function(id) {
    const newName = prompt('Enter new name:');
    if (newName) {
      db.collection('menu_items').doc(id).update({
        name: newName
      }).then(loadMenuItems);
    }
  };

  // Delete menu item
  window.deleteItem = function(id) {
    if (confirm('Are you sure you want to delete this item?')) {
      db.collection('menu_items').doc(id).delete()
        .then(loadMenuItems);
    }
  };

  // Initial load
  loadMenuItems();
});