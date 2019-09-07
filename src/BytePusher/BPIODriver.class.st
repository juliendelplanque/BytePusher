Class {
	#name : #BPIODriver,
	#superclass : #Object,
	#category : #'BytePusher-Core'
}

{ #category : #accessing }
BPIODriver class >> default [
	^ BPIOMorphicDriver new
]

{ #category : #api }
BPIODriver >> keyPressed [
	"Returns an integer on 16 bits. Each bit is a key of the keyboard. Left-most bit is key 1, right-most is key F."
	^ self subclassResponsibility
]
