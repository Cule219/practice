class LinedList {
    constructor() {
        this.head = null;
        this.size = 0;
    }

    // Adds and element at the end of the list
    add(element) {
        // create a new Node
        let node = new Node(element);
        if(this.head == null) {
            this.head = node;
        } 
        else {
            let current = this.head;
            // iterate to the end of the list
            while(current.next) {
                current = current.next
            }
            current.next = node;
        }
        this.size++;
    }

    insertAt(element, location) {
        let node = new Node(element);

        let index = 0;
        let current = this.head;

        while(current.next && index < location-1) {
            current = current.next;
            index++;
        }
        if(index !== location-1) {
            return 'Location not available, check the size of the list with: size_Of_List';
        } else {
            // Assign next of current Node at the location -1 to new Node
            node.next = current.next;
            // Assign new Node to the next of previous Node
            current.next = node.next;
        }
        this.size++;
    }
    removeFrom(location) {
        // Node to be removed
        let current = this.head;
        let index = 0;
        while(current.next && index < location - 1) {
            current = current.next;
            index++;
        }
        if(!current.next || index !== location-1) {
            return 'Node not available, check the size of the list with: size_Of_List';
        } else {
            current.next = curent.next.next
        }
        if(current.next) {
            this.size--;
        }
    }
    removeElement(element) {
        let current = this.head;
        let theElement;
        if(current === element) {
            theElement = this.head;
            this.head = this.head.next;
        } else {
            while(current.next && !theElement) {
                if(current.next.element === element) {
                    theElement = current.next.element;
                    curent.next = curent.next.next;
                }
            } 
        }
        if(!theElement) {
            return 'The element is not in the list';
        } else {
            this.size--;
        }
    }
  
    // Helper Methods 
    isEmpty () {
        return !this.length;
    }
    size_Of_List() {
        return this.size;
    }
    PrintList() {
        let current = this.head;
        let list = [];
        while(current.next) {
            // printing line by line;
            console.log(current.element);
            list.push(current.element);
            current = current.next;
        }
        // priniting entire list
        console.log(current.element);
    }
}