#!/usr/bin/env bash
# ============================================================
# DancingBox — upload all videos to GitHub Releases
# Run this once from inside the site_for_github/ folder:
#   cd site_for_github
#   bash upload_videos.sh
#
# Requirements: gh (GitHub CLI), authenticated via `gh auth login`
# ============================================================

set -e

REPO="YYYYYHC/DancingBox"   # ← change if your repo name differs
TAG="v1.0"
TITLE="Supplemental Videos"
NOTES="All video assets for the DancingBox project page (CHI 2026)."

# ── 1. Create release ────────────────────────────────────────
echo "Creating release $TAG..."
gh release create "$TAG" \
  --repo "$REPO" \
  --title "$TITLE" \
  --notes "$NOTES"

# ── 2. Helper: upload with a flat unique name ────────────────
upload() {
  local src="$1"   # original path
  local name="$2"  # asset name on GitHub
  local tmp="/tmp/gh_upload_${name}"
  cp "$src" "$tmp"
  echo "  Uploading $name..."
  gh release upload "$TAG" "$tmp#$name" --repo "$REPO"
  rm "$tmp"
}

# ── 3. Supplemental video ────────────────────────────────────
echo "Uploading supplemental video..."
upload "videos/supplemental.mp4" "supplemental.mp4"

# ── 4. Creative task ─────────────────────────────────────────
echo "Uploading creative task videos..."
for i in 1 2 3 4 5 6 7 8 9; do
  upload "videos/creative/P${i}.mp4" "creative_P${i}.mp4"
done

# ── 5. Replication tasks ─────────────────────────────────────
echo "Uploading replication task videos..."
for task in task1 task2 task3; do
  upload "videos/replication/${task}/target.mp4" "replication_${task}_target.mp4"
  for i in 1 2 3 4 5 6 7 8 9; do
    upload "videos/replication/${task}/P${i}.mp4" "replication_${task}_P${i}.mp4"
  done
done

# ── 6. Figure animations ─────────────────────────────────────
echo "Uploading figure animations..."
upload "videos/figures/fig1_b.mp4"          "figures_fig1_b.mp4"
upload "videos/figures/fig1_c.mp4"          "figures_fig1_c.mp4"
upload "videos/figures/fig3_mocap.mp4"      "figures_fig3_mocap.mp4"
upload "videos/figures/fig7_composition.mp4" "figures_fig7_composition.mp4"
upload "videos/figures/fig7_papercut.mp4"   "figures_fig7_papercut.mp4"
upload "videos/figures/fig7_phone.mp4"      "figures_fig7_phone.mp4"
upload "videos/figures/fig9_ablation.mp4"   "figures_fig9_ablation.mp4"
upload "videos/figures/fig10_keyframing.mp4" "figures_fig10_keyframing.mp4"

echo ""
echo "✅ All videos uploaded to https://github.com/${REPO}/releases/tag/${TAG}"
