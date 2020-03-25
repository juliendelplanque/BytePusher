Class {
	#name : #BPBankInitializer,
	#superclass : #BPMemoryInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPBankInitializer class >> bankSize [
	^ 16rFFFF
]
