document.addEventListener('DOMContentLoaded', function() {
  const ordersContainer = document.getElementById('orders');

  // Load existing orders
  function loadOrders() {
    db.collection('orders')
      .orderBy('timestamp', 'desc')
      .get()
      .then((querySnapshot) => {
        ordersContainer.innerHTML = '';
        querySnapshot.forEach((doc) => {
          const order = doc.data();
          const orderElement = document.createElement('li');
          orderElement.className = 'mb-4 p-4 border rounded-lg bg-white shadow-sm';
          orderElement.innerHTML = `
            <div class="flex justify-between items-start">
              <div>
                <h3 class="font-bold text-lg">Order #${doc.id.substring(0, 8)}</h3>
                <p class="text-gray-600">${new Date(order.timestamp?.toDate()).toLocaleString()}</p>
                <div class="mt-2">
                  <span class="inline-block px-2 py-1 rounded-full text-xs font-semibold 
                    ${order.status === 'Delivered' ? 'bg-green-100 text-green-800' : 
                      order.status === 'Preparing' ? 'bg-yellow-100 text-yellow-800' : 
                      'bg-blue-100 text-blue-800'}">
                    ${order.status}
                  </span>
                </div>
                <p class="mt-1">Total: <span class="font-bold">$${order.total.toFixed(2)}</span></p>
                <p>Payment: ${order.paymentMethod}</p>
              </div>
              <div class="flex space-x-2">
                <select onchange="updateOrderStatus('${doc.id}', this.value)" 
                  class="border rounded p-1 text-sm">
                  <option value="Preparing" ${order.status === 'Preparing' ? 'selected' : ''}>Preparing</option>
                  <option value="Out for Delivery" ${order.status === 'Out for Delivery' ? 'selected' : ''}>Out for Delivery</option>
                  <option value="Delivered" ${order.status === 'Delivered' ? 'selected' : ''}>Delivered</option>
                </select>
                <button onclick="deleteOrder('${doc.id}')" 
                  class="bg-red-500 text-white px-2 py-1 rounded text-sm">
                  Delete
                </button>
              </div>
            </div>
            <div class="mt-2 border-t pt-2">
              <h4 class="font-semibold">Items:</h4>
              <ul class="list-disc pl-5">
                ${order.items.map(item => `
                  <li>${item.quantity}x ${item.name} ($${item.price.toFixed(2)})</li>
                `).join('')}
              </ul>
            </div>
          `;
          ordersContainer.appendChild(orderElement);
        });
      });
  }

  // Update order status
  window.updateOrderStatus = function(orderId, newStatus) {
    db.collection('orders').doc(orderId).update({
      status: newStatus,
      updatedAt: firebase.firestore.FieldValue.serverTimestamp()
    }).then(() => {
      loadOrders();
    });
  };

  // Delete order
  window.deleteOrder = function(orderId) {
    if (confirm('Are you sure you want to delete this order?')) {
      db.collection('orders').doc(orderId).delete()
        .then(() => {
          loadOrders();
        });
    }
  };

  // Initial load
  loadOrders();

  // Set up real-time listener
  db.collection('orders')
    .orderBy('timestamp', 'desc')
    .onSnapshot((snapshot) => {
      loadOrders();
    });
});