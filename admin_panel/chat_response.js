document.addEventListener('DOMContentLoaded', function() {
    const activeChats = document.getElementById('activeChats');
    const chatWindow = document.getElementById('chatWindow');
    const noChatSelected = document.getElementById('noChatSelected');
    const chatTitle = document.getElementById('chatTitle');
    const messagesContainer = document.getElementById('messages');
    const messageInput = document.getElementById('messageInput');
    const sendButton = document.getElementById('sendButton');
    
    let currentChatId = null;
    const database = firebase.database();

    // Load active chats
    function loadActiveChats() {
        database.ref('chats').on('value', (snapshot) => {
            activeChats.innerHTML = '';
            const chats = snapshot.val();
            
            if (chats) {
                Object.keys(chats).forEach(chatId => {
                    const chat = chats[chatId];
                    const lastMessage = chat.messages 
                        ? chat.messages[Object.keys(chat.messages).pop()] 
                        : null;
                    
                    const chatElement = document.createElement('div');
                    chatElement.className = `p-2 border rounded cursor-pointer hover:bg-gray-100 
                        ${currentChatId === chatId ? 'bg-blue-50 border-blue-300' : ''}`;
                    chatElement.innerHTML = `
                        <div class="font-semibold">${chat.customerName || 'Customer'}</div>
                        <div class="text-sm text-gray-600 truncate">
                            ${lastMessage ? lastMessage.text : 'No messages yet'}
                        </div>
                    `;
                    chatElement.addEventListener('click', () => openChat(chatId, chat.customerName));
                    activeChats.appendChild(chatElement);
                });
            }
        });
    }

    // Open chat with customer
    function openChat(chatId, customerName) {
        currentChatId = chatId;
        chatTitle.textContent = `Chat with ${customerName}`;
        chatWindow.classList.remove('hidden');
        noChatSelected.classList.add('hidden');
        loadMessages(chatId);
    }

    // Load messages for a chat
    function loadMessages(chatId) {
        database.ref(`chats/${chatId}/messages`).on('value', (snapshot) => {
            messagesContainer.innerHTML = '';
            const messages = snapshot.val();
            
            if (messages) {
                Object.values(messages).forEach(message => {
                    const messageElement = document.createElement('div');
                    messageElement.className = `mb-2 p-2 rounded max-w-xs 
                        ${message.sender === 'admin' ? 'bg-blue-100 ml-auto' : 'bg-gray-100'}`;
                    messageElement.textContent = message.text;
                    messagesContainer.appendChild(messageElement);
                });
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
        });
    }

    // Send message
    sendButton.addEventListener('click', sendMessage);
    messageInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') sendMessage();
    });

    function sendMessage() {
        if (!currentChatId || !messageInput.value.trim()) return;
        
        const newMessage = {
            text: messageInput.value.trim(),
            sender: 'admin',
            timestamp: firebase.database.ServerValue.TIMESTAMP
        };

        database.ref(`chats/${currentChatId}/messages`).push(newMessage)
            .then(() => {
                messageInput.value = '';
            });
    }

    // Initial load
    loadActiveChats();
});