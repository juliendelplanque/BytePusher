Class {
	#name : #BPPageInitializer,
	#superclass : #BPMemoryInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPPageInitializer class >> bankSize [
	^ 16rFF
]
