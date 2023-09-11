# Merkle tree

Code example:
```
package org.example.MerkleTree;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

public class MerkleTree {
    MTNode root;
    private static final char[] hex = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

    public MerkleTree(ArrayList<String> dataBlocks) {
        this.root = generateTree(dataBlocks);
    }

    public static String generateHash(String originalString) {
        byte[] bytes = originalString.getBytes();
        StringBuffer sb = new StringBuffer(bytes.length * 2);
        for(final byte b : bytes) {
            sb.append(hex[(b & 0xF0) >> 4]);
            sb.append(hex[b & 0x0F]);
        }
        return sb.toString();
    }

    public static MTNode generateTree(ArrayList<String> dataBlocks) {
        ArrayList<MTNode> childNodes = new ArrayList<>();

        for (String message : dataBlocks) {
            childNodes.add(new MTNode(null, null, generateHash(message)));
        }

        return buildTree(childNodes);
    }

    private static MTNode buildTree(ArrayList<MTNode> children) {
        ArrayList<MTNode> parents = new ArrayList<>();

        while (children.size() != 1) {
            for (int i = 0; i < children.size(); i += 2) {
                MTNode leftChild = children.get(i);
                MTNode rightChild;

                if (i + 1 < children.size()) {
                    rightChild = children.get(i + 1);
                } else {
                    rightChild = new MTNode(null, null, leftChild.hash);
                }

                String parentHash = generateHash(leftChild.hash + rightChild.hash);
                parents.add(new MTNode(leftChild, rightChild, parentHash));
            }

            children = parents;
            parents = new ArrayList<>();
        }
        return children.get(0);
    }

    public void print() {
        if (this.root == null) {
            return;
        }

        if ((this.root.left == null && this.root.right == null)) {
            System.out.println(this.root.hash);
        }
        Queue<MTNode> queue = new LinkedList<>();
        queue.add(this.root);
        queue.add(null);

        while (!queue.isEmpty()) {
            MTNode node = queue.poll();
            if (node != null) {
                System.out.println(node.hash);
            } else {
                System.out.println();
                if (!queue.isEmpty()) {
                    queue.add(null);
                }
            }

            if (node != null && node.left != null) {
                queue.add(node.left);
            }

            if (node != null && node.right != null) {
                queue.add(node.right);
            }
        }
    }
}

public class MTNode {
    public final MTNode left;
    public final MTNode right;
    public final String hash;

    public MTNode(MTNode left, MTNode right, String hash) {
        this.left = left;
        this.right = right;
        this.hash = hash;
    }
}
```

# Linked list
Code example:
```
public class MyLinkedList<T> {
    LLNode<T> head;
    LLNode<T> tail;
    int length;

    public MyLinkedList() {
        this.length = 0;
    }

    public void add(T t) {
        LLNode<T> node = new LLNode<>(t);
        if (this.length == 0) {
            this.head = node;
        } else {
            this.tail.setNext(node);
        }

        this.tail = node;
        this.length++;
    }

    public T get(int index) {
        if (index >= this.length) {
            throw new RuntimeException("Index out of bounds");
        } else {
            LLNode<T> node = this.head;
            for (int i = 0; i < index; i++) {
                node = node.next;
            }

            return node.value;
        }
    }

    public void delete(int index) {
        if (index >= this.length) {
            throw new RuntimeException("Index out of bounds");
        } else if (index == 0) {
            this.head = this.head.next;
        } else {
            LLNode<T> node = this.head;
            for (int i = 0; i < index - 1; i++) {
                node = node.next;
            }

            node.next = node.next.next;
        }

        this.length--;
    }

    public void print() {
        LLNode<T> node = this.head;
        for (int i = 0; i < this.length; i++) {
            System.out.print(node.value);
            System.out.print(" ");
            node = node.next;
        }
        System.out.println();
    }
}

public class LLNode<T> {
    LLNode<T> next;
    T value;

    LLNode(T value) {
        this.value = value;
        this.next = null;
    }

    void setNext(LLNode<T> node) {
        this.next = node;
    }
}
```

# Hashing
Code example:
```
public static String generateHash(String originalString) {
    byte[] bytes = originalString.getBytes();
    StringBuffer sb = new StringBuffer(bytes.length * 2);
    for(final byte b : bytes) {
        sb.append(hex[(b & 0xF0) >> 4]);
        sb.append(hex[b & 0x0F]);
    }
    return sb.toString();
}
```