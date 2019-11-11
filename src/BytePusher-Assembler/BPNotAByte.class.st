"
I am the error raised when an integer should be a byte (between 0 and 255) but is not.
"
Class {
	#name : #BPNotAByte,
	#superclass : #BPError,
	#instVars : [
		'value'
	],
	#category : #'BytePusher-Assembler-Errors'
}

{ #category : #'instance creation' }
BPNotAByte class >> signalForValue: value [
	^ self new
		value: value;
		signal
]

{ #category : #accessing }
BPNotAByte >> value [
	^ value
]

{ #category : #accessing }
BPNotAByte >> value: anObject [
	value := anObject
]
