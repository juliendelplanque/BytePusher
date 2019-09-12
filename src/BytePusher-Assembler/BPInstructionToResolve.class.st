Class {
	#name : #BPInstructionToResolve,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'jump'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #'instance creation' }
BPInstructionToResolve class >> from: from to: to jump: jump [
	^ self new
		from: from;
		to: to;
		jump: jump;
		yourself
]

{ #category : #accessing }
BPInstructionToResolve >> from [
	^ from
]

{ #category : #accessing }
BPInstructionToResolve >> from: anObject [
	from := anObject
]

{ #category : #accessing }
BPInstructionToResolve >> jump [
	^ jump
]

{ #category : #accessing }
BPInstructionToResolve >> jump: anObject [
	jump := anObject
]

{ #category : #accessing }
BPInstructionToResolve >> to [
	^ to
]

{ #category : #accessing }
BPInstructionToResolve >> to: anObject [
	to := anObject
]
