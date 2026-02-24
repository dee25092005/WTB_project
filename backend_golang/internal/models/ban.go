package models

type Ban struct {
	ID          uint   `json:"id,omitempty"`
	Name        string `json:"name"`
	District    string `json:"district"`
	Coordinates string `json:"coordinates"`
	LandmarkURL string `json:"landmark_url"`
	XPPoints    int    `json:"xp_points"`
	CreatedAt   string `json:"created_at"`
}
